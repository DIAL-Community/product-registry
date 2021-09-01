# frozen_string_literal: true

require 'modules/slugger'
require 'modules/constants'
require 'modules/maturity_sync'
require 'modules/discourse'

class ApplicationController < ActionController::Base
  include Modules::Slugger
  include Modules::Constants
  include Modules::MaturitySync
  include Modules::Discourse
  include Pundit
  include FilterConcern
  protect_from_forgery prepend: true

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :configure_registration_parameters, if: :devise_controller?
  before_action :check_password_expiry
  before_action :set_default_identifier
  before_action :set_portal
  before_action :set_org_session

  around_action :set_locale

  after_action :store_action

  def default_url_options
    if !request.query_parameters['user_token'].nil?
      {
        'user_email': request.query_parameters['user_email'],
        'user_token': request.query_parameters['user_token']
      }
    else 
      {}
    end
  end

  def not_found
    raise ActionController::RoutingError, 'Not Found'
  end

  def set_default_identifier
    logger.info("Default session identifier: #{session[:default_identifier]}.")
    if session[:default_identifier].nil?
      session[:default_identifier] = SecureRandom.uuid

      user_event = UserEvent.new
      user_event.identifier = session[:default_identifier]
      if request.path_info.include?('/api/v1/')
        user_event.event_type = UserEvent.event_types[:api_request]
      else
        user_event.event_type = UserEvent.event_types[:initial_load]
      end
      user_event.event_datetime = Time.now

      if user_event.save!
        logger.info("User event '#{user_event.event_type}' for #{user_event.identifier} saved.")
      end
    end
  end

  def set_locale(&action)
    if params[:locale].present?
      accept_language = params[:locale]
      if I18n.available_locales.index(accept_language[0..1].to_sym)
        I18n.locale = accept_language[0..1].to_sym
      end
      session[:locale] = I18n.locale.to_s
    end

    if session[:locale].nil?
      accept_language = request.env['HTTP_ACCEPT_LANGUAGE']
      if accept_language
        accept_language.scan(/[a-z]{2}(?=;)/).first
        if I18n.available_locales.index(accept_language[0..1].to_sym)
          I18n.locale = accept_language[0..1].to_sym
        end
      end
      session[:locale] = I18n.locale.to_s
    end

    logger.info("Setting locale to '#{session[:locale]}.'")
    I18n.with_locale(session[:locale], &action)
  end

  def update_locale
    if params[:id] == 'en'
      I18n.locale = :en
      session[:locale] = "en"
    elsif params[:id] == 'de'
      I18n.locale = :de
      session[:locale] = "de"
    end
    redirect_back fallback_location: root_path
  end

  def set_portal
    if session[:portal_subdomain].nil?
      default_url = Setting.where(slug: 'root_domain').first
      if default_url.nil?
        session[:portal_subdomain] = false
      else
        session[:portal_subdomain] = true
      end
    end

    if session[:portal].nil?
      if session[:portal_subdomain]
        # Get current URL, strip off root domain to get subdomain and check against portal_view table
        root_domain = Setting.where(slug: 'root_domain').first.value
        subdomain = request.host.split(root_domain)[0]
        if !subdomain.nil?
          subdomain_portal = PortalView.where(subdomain: subdomain.chomp('.')).first
          if !subdomain_portal.nil?
            session[:portal] = subdomain_portal
          end
        end
      end
      if session[:portal].nil?
        if current_user.nil?
          session[:portal] = PortalView.where(slug: 'default').first
        else
          PortalView.all.order(:id).each do |portal|
            if !(portal.user_roles && current_user.roles).empty?
              session[:portal] = portal
              break
            end
          end
        end
      end
    end
  end

  def set_org_session
    if params[:org]
      session[:org] = params[:org]
    end
  end

  def check_password_expiry
    # Only execute this check when user is trying to log into the application.
    return if params[:controller] != 'devise/sessions' || !%w[new create].include?(params[:action])
    return if !current_user || !current_user.password_expire?

    logger.info('User is expired! Forcing user to change their password!')

    @expiring_user = current_user
    reset_token = @expiring_user.generate_reset_token
    sign_out(current_user)
    redirect_to(edit_password_url(@expiring_user, reset_password_token: reset_token))
  end

  def generate_offset(first_duplicate)
    size = 1
    if !first_duplicate.nil?
      size = first_duplicate.slug
                            .slice(/_dup\d+$/)
                            .delete('^0-9')
                            .to_i + 1
      logger.info("Slug dupes: #{first_duplicate.slug
                                                .slice(/_dup\d+$/)
                                                .delete('^0-9')
                                                .to_i}")
    end
    "_dup#{size}"
  end

  def update_cookies(filter_name)
    case filter_name
    when 'products', 'origins', 'with_maturity_assessment', 'is_launchable', 'product_type',
         'organizations', 'projects', 'tags', 'sectors'
      session[:updated_prod_filter] = true
    end
  end

  def object_counts
    all_filters, filter_set = sanitize_all_filters

    # Filter out organizations based on filter input.
    org_ids = get_organizations_from_filters(all_filters)
    org_products = get_org_products(all_filters)
    products = get_products_from_filters(all_filters)

    project_product_ids = get_products_from_projects(all_filters, org_ids)

    sdgs = filter_sdgs(all_filters, filter_set, project_product_ids, org_ids, org_products, products)
    use_cases = filter_use_cases(all_filters, filter_set, project_product_ids, org_ids, org_products, products)
    workflows = filter_workflows(all_filters, filter_set, project_product_ids, org_ids, org_products, products)
    bbs = filter_building_blocks(all_filters, filter_set, project_product_ids, org_ids, org_products, products)
    projects = filter_projects(all_filters, filter_set, project_product_ids, org_ids, org_products, products)
    products = filter_products(all_filters, filter_set, project_product_ids, org_ids, org_products, products)
    orgs = filter_organizations(all_filters, filter_set, project_product_ids, org_ids, org_products, products)
    playbooks = filter_playbooks(all_filters, filter_set, project_product_ids, org_ids, org_products, products)

    render json: { "sdgCount": sdgs.count, "useCaseCount": use_cases.count, "workflowCount": workflows.count, "bbCount": bbs.count,
           "projectCount": projects.count, "productCount": products.count, "orgCount": orgs.count, "playbookCount": playbooks.count}
    
  end

  def remove_filter
    return unless params.key? 'filter_array'

    logger.debug("Removing filter: #{params['filter_array'].values}.")

    filter_array = params['filter_array'].values
    filter_array.each do |curr_filter|
      filter_name = curr_filter['filter_name']
      filter_obj = {}
      if curr_filter['filter_value']
        filter_obj['value'] = curr_filter['filter_value']
        filter_obj['label'] = curr_filter['filter_label']
        existing_value = session[filter_name.to_s]
        existing_value.delete(filter_obj)
        existing_value.empty? && session.delete(filter_name.to_s)
        !existing_value.empty? && session[filter_name.to_s] = existing_value
      else
        existing_value = session[filter_name.to_s]
        existing_value&.delete(filter_obj)
        session.delete(filter_name.to_s)
      end
      update_cookies(filter_name)
    end
    # Mark when the filter was last updated
    session[:filtered_time] = DateTime.now.strftime('%Q')
    render json: true
  end

  def add_filters
    return unless params.key?('filters')

    retval = false

    filters = params['filters'].values
    filters.each do |filter|
      filter_name = filter['filter_name']
      filter_obj = {}
      filter_obj['value'] = filter['filter_value']
      filter_obj['label'] = filter['filter_label']
      if filter['filter_label'].nil? || filter['filter_label'].empty?
        session[filter_name.to_s] = filter_obj
        retval = true
      else
        existing_value = session[filter_name.to_s]
        existing_value.nil? && existing_value = []
        unless existing_value.include?(filter_obj)
          existing_value.push(filter_obj)
          retval = true
        end
        session[filter_name.to_s] = existing_value
      end
      update_cookies(filter_name)
    end

    session[:filtered_time] = Time.now.strftime('%Q')
    render(json: retval)
  end

  def add_filter
    return unless params.key? 'filter_name'

    logger.debug("Adding filter: #{params['filter_name']} -> {#{params['filter_value']}, #{params['filter_label']}}.")

    retval = false
    filter_name = params['filter_name']
    filter_obj = {}
    filter_obj['value'] = params['filter_value']
    filter_obj['label'] = params['filter_label']
    if params['filter_label'].nil? || params['filter_label'].empty?
      session[filter_name.to_s] = filter_obj
      retval = true
    else
      existing_value = session[filter_name.to_s]
      existing_value.nil? && existing_value = []
      if !existing_value.include? filter_obj
        existing_value.push(filter_obj)
        retval = true
      end
      session[filter_name.to_s] = existing_value
    end
    update_cookies(filter_name)
    session[:filtered_time] = DateTime.now.strftime('%Q')
    render json: retval
  end

  def remove_all_filters
    logger.info 'Removing all filters'
    ORGANIZATION_FILTER_KEYS.each do |key|
      if session[key]
        session.delete(key)
      end
    end
    FRAMEWORK_FILTER_KEYS.each do |key|
      if session[key]
        session.delete(key)
      end
    end
    session[:filtered_time] = DateTime.now.strftime('%Q')
    render json: true
  end

  def get_filters
    filters = {}
    ORGANIZATION_FILTER_KEYS.each do |key|
      if session[key]
        logger.debug "Organization filter in session: #{session[key]}"
        filters[key] = session[key]
      end
    end
    FRAMEWORK_FILTER_KEYS.each do |key|
      if session[key]
        logger.debug "Framework filter in session: #{session[key]}"
        filters[key] = session[key]
      end
    end
    render json: filters
  end

  def sanitize_all_filters
    all_filters = {}
    all_filters["use_cases"] = sanitize_session_values 'use_cases'
    all_filters["workflows"] = sanitize_session_values 'workflows'
    all_filters["sdgs"] = sanitize_session_values 'sdgs'
    all_filters["bbs"] = sanitize_session_values 'building_blocks'
    all_filters["products"] = sanitize_session_values 'products'
    all_filters["origins"] = sanitize_session_values 'origins'
    all_filters["organizations"] = sanitize_session_values 'organizations'
    all_filters["projects"] = sanitize_session_values 'projects'
    all_filters["project_origins"] = sanitize_session_values 'project_origins'

    all_filters["endorser_only"] = sanitize_session_value 'endorser_only'
    all_filters["aggregator_only"] = sanitize_session_value 'aggregator_only'
    all_filters["years"] = sanitize_session_values 'years'

    all_filters["countries"] = sanitize_session_values 'countries'
    all_filters["sectors"] = sanitize_session_values 'sectors'

    all_filters["with_maturity_assessment"] = sanitize_session_value 'with_maturity_assessment'
    all_filters["is_launchable"] = sanitize_session_value 'is_launchable'

    all_filters["tags"] = sanitize_session_values 'tags'
    all_filters["product_type"] = sanitize_session_values 'product_type'

    filter_set = !(all_filters["countries"].empty? && all_filters["products"].empty? && all_filters["sectors"].empty? && 
                     all_filters["years"].empty? && all_filters["organizations"].empty? && all_filters["origins"].empty? && 
                     all_filters["projects"].empty? && all_filters["project_origins"].empty? && all_filters["tags"].empty? && 
                     all_filters["sdgs"].empty? && all_filters["use_cases"].empty? && all_filters["workflows"].empty? && 
                     all_filters["bbs"].empty? && all_filters["product_type"].empty?) ||
                     all_filters["endorser_only"] || all_filters["aggregator_only"] || 
                     all_filters["with_maturity_assessment"] || all_filters["is_launchable"]

    return all_filters, filter_set
  end

  def sanitize_filter_values(filter_name)
    filter_values = []
    params.key?(filter_name.to_s) &&
      filter_values += params[filter_name.to_s].reject { |value| value.nil? || value.blank? }
    filter_values
  end

  def sanitize_filter_value(filter_name)
    filter_value = nil
    (params.key? filter_name.to_s) && filter_value = params[filter_name.to_s]
    filter_value
  end

  def sanitize_session_values(filter_name)
    filter_values = []
    if session.key? filter_name.to_s
      session[filter_name.to_s].each do |curr_filter|
        filter_value = curr_filter['value']
        if filter_value.scan(/\D/).empty?
          filter_value = filter_value.to_i
        end
        filter_values.push(filter_value)
      end
    end
    filter_values
  end

  def sanitize_session_value(filter_name)
    filter_value = nil
    (session.key? filter_name.to_s) && filter_value = session[filter_name.to_s]['value']
    filter_value.to_s.downcase == 'true'
  end

  def get_use_cases_from_workflows(workflows)
    use_cases_ids = []
    if !workflows.empty?
      workflow_use_cases = UseCaseStep.joins(:workflows)
                                      .where('workflows.id in (?)', workflows)
                                      .select('use_case_id')
                                      .pluck('use_case_id')
      use_cases_ids = workflow_use_cases
    end
    use_cases_ids
  end

  def get_use_cases_from_bbs(bbs)
    use_cases_ids = []
    if !bbs.empty?
      bb_workflows = Workflow.joins(:building_blocks)
                             .where('building_blocks.id in (?)', bbs)
      bb_use_cases = UseCaseStep.joins(:workflows)
                                .where('workflows.id in (?)', bb_workflows.ids)
                                .select('use_case_id')
                                .pluck('use_case_id')
      use_cases_ids = bb_use_cases
    end
    use_cases_ids
  end

  def get_use_cases_from_sdgs(sdgs)
    use_cases_ids = []
    if !sdgs.empty?
      sdgs = SustainableDevelopmentGoal.where(id: sdgs)
                                       .select(:number)
      sdg_targets = SdgTarget.where('sdg_number in (?)', sdgs)
      sdg_use_cases = UseCase.joins(:sdg_targets)
                             .where('sdg_targets.id in (?)', sdg_targets.ids)
      use_cases_ids = sdg_use_cases.ids
    end
    use_cases_ids
  end

  def get_workflows_from_use_cases(use_cases)
    workflow_ids = []
    if !use_cases.nil? && !use_cases.empty?
      workflow_use_cases = Workflow.joins(:use_case_steps)
                                   .where('use_case_steps.use_case_id in (?)', use_cases)
      workflow_ids = workflow_use_cases.ids
    end
    workflow_ids
  end

  def get_workflows_from_sdgs(sdgs)
    workflow_ids = []
    if !sdgs.empty?
      sdgs = SustainableDevelopmentGoal.where(id: sdgs)
                                       .select(:number)
      sdg_targets = SdgTarget.where('sdg_number in (?)', sdgs)
      sdg_use_cases = UseCase.joins(:sdg_targets)
                             .where('sdg_targets.id in (?)', sdg_targets.ids)
      workflow_sdgs = Workflow.joins(:use_case_steps)
                              .where('use_case_steps.use_case_id in (?)', sdg_use_cases.ids)
      workflow_ids = workflow_sdgs.ids
    end
    workflow_ids
  end

  def get_workflows_from_bbs(bbs)
    workflow_ids = []
    if !bbs.empty?
      workflow_bbs = Workflow.joins(:building_blocks)
                             .where('building_blocks.id in (?)', bbs)
      workflow_ids = workflow_bbs.ids
    end
    workflow_ids
  end

  def get_workflows_from_products(products)
    workflow_ids = []
    if !products.empty?
      product_bbs = BuildingBlock.joins(:products)
                                 .where('products.id in (?)', products)
      bb_workflows = Workflow.joins(:building_blocks)
                             .where('building_blocks.id in (?)', product_bbs.ids)
      workflow_ids = bb_workflows.ids
    end
    workflow_ids
  end

  def get_bbs_from_use_cases(use_cases)
    bbs_ids = []
    if !use_cases.empty?
      use_case_workflows = Workflow.joins(:use_case_steps)
                                   .where('use_case_steps.use_case_id in (?)', use_cases)
      use_case_bbs = BuildingBlock.joins(:workflows)
                                  .where('workflows.id in (?)', use_case_workflows.ids)
      bbs_ids += use_case_bbs.ids
    end
    bbs_ids
  end

  def get_bbs_from_workflows(workflows)
    bbs_ids = []
    if !workflows.empty?
      workflow_bbs = BuildingBlock.joins(:workflows)
                                  .where('workflows.id in (?)', workflows)
      bbs_ids += workflow_bbs.ids
    end
    bbs_ids
  end

  def get_bbs_from_products(products)
    bbs_ids = []
    if !products.empty?
      product_bbs = BuildingBlock.joins(:products)
                                 .where('products.id in (?)', products)
      bbs_ids = product_bbs.ids
    end
    bbs_ids
  end

  def save_url
    if current_user.nil?
      return respond_to { |format| format.json { render json: {}, status: :unauthorized } }
    end

    favoriting_user = current_user
    favoriting_user.saved_urls.push(params[:url])

    respond_to do |format|
      if favoriting_user.save!
        format.json { render json: { saved_url: params[:url] }, status: :ok }
      else
        format.json { render json: { saved_url: params[:url] }, status: :unprocessable_entity }
      end
    end
  end

  def remove_url
    if current_user.nil?
      return respond_to { |format| format.json { render json: {}, status: :unauthorized } }
    end

    favoriting_user = current_user
    deleted_url = favoriting_user.saved_urls.delete_at(params[:index].to_i)

    respond_to do |format|
      if favoriting_user.save!
        format.json { render json: { deleted_url: deleted_url }, status: :ok }
      else
        format.json { render json: { deleted_url: deleted_url }, status: :unprocessable_entity }
      end
    end
  end

  protected

  def filter_and_intersect_arrays(arrays)
    return [] unless arrays.is_a?(Array)

    filtered_arrays = arrays.reject { |x| x.nil? || x.length <= 0 }
                            .sort { |a, b| a.length <=> b.length }

    intersected_array = filtered_arrays[0]
    filtered_arrays.each do |x|
      intersected_array &= x
    end

    return [] if intersected_array.nil?

    intersected_array
  end

  def configure_registration_parameters
    logger.info('Configuring custom registration parameters.')
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit(:email, :username, :password, :password_confirmation, :organization_id, user_products: [])
    end
  end

  private

  def user_not_authorized(exception)
    respond_to do |format|
      format.html do
        redirect_to request.referrer || root_path,
                    flash: { error: t(exception.query.to_s), scope: 'pundit', default: :default }
      end
      format.json { render json: {}, status: 401 }
    end
  end

  def store_action
    return unless request.get? 
    if (request.path != "/users/sign_in" &&
        request.path != "/users/sign_up" &&
        request.path != "/users/password/new" &&
        request.path != "/users/password/edit" &&
        request.path != "/users/confirmation" &&
        request.path != "/users/sign_out" &&
        request.path != "/export" &&
        !request.path.include?('stylesheets') &&
        !request.xhr?) # don't store ajax calls
      store_location_for(:user, request.fullpath)
    end
  end
end
