# frozen_string_literal: true

require 'modules/slugger'
require 'modules/constants'
require 'modules/maturity_sync'

class ApplicationController < ActionController::Base
  include Modules::Slugger
  include Modules::Constants
  include Modules::MaturitySync
  include Pundit
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :configure_registration_parameters, if: :devise_controller?
  before_action :check_password_expiry
  before_action :set_locale
  before_action :set_portal

  after_action :store_action

  def not_found
    raise ActionController::RoutingError, 'Not Found'
  end

  def set_locale
    accept_language = request.env['HTTP_ACCEPT_LANGUAGE']
    if accept_language
      accept_language.scan(/[a-z]{2}(?=;)/).first
      if I18n.available_locales.index(accept_language[0..1].to_sym)
        I18n.locale = accept_language[0..1].to_sym
      end
    end
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
            if portal.user_roles.include?(current_user.role)
              session[:portal] = portal
              break
            end
          end
        end
      end
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
    when 'products', 'origins', 'with_maturity_assessment', 'is_launchable', 'product_type','organizations', 'projects', 'tags'
      session[:updated_prod_filter] = true
    end
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

  def get_products_from_filters(products, origins, with_maturity_assessment, is_launchable, product_type, tags)
    # Check to see if the filter has already been set
    product_list = []
    if session[:updated_prod_filter].nil? || session[:updated_prod_filter].to_s.downcase == 'true'
      filter_products = Product.all
      if !products.empty?
        filter_products = Product.all.where('products.id in (?)', products)
      end

      if !origins.empty?
        origin_list = Origin.where('origins.id in (?)', origins)

        # Also filter origins using the portal configuration.
        if !session[:portal]['product_views'].nil?
          origin_list = origin_list.where('origins.name in (?)', session[:portal]['product_views'])
        end

        # Filter products based on the origin information
        !origin_list.empty? && filter_products = filter_products.joins(:origins)
                                                                .eager_load('origins')
                                                                .where('origins.id in (?)', origin_list.ids)
      end

      if !product_type.empty?
        filter_products = filter_products.where("product_type in (?) ", product_type.map(&:downcase).join(','))
      end

      if !tags.empty?
        filter_products = filter_products.where("tags @> '{#{tags.map(&:downcase).join(',')}}'::varchar[]")
      end

      if is_launchable
        filter_products = filter_products.where('is_launchable is true')
      end

      if with_maturity_assessment
        filter_products = filter_products.where('maturity_score > 0')
      end

      product_filter_set = (!products.empty? || !origins.empty? || !tags.empty? ||
                             with_maturity_assessment || is_launchable || product_type)

      if product_filter_set
        product_list += filter_products.ids
      end

      # Set the cookies for caching
      session[:updated_prod_filter] = false
      session[:filter_products] = product_list.join(',')
      session[:prod_filter_set] = product_filter_set
    else
      product_list = session[:filter_products].split(',').map(&:to_i)
    end
    product_list
  end

  def get_products_from_projects(projects)
  end

  def get_organizations_from_filters(organizations, years, sectors, countries, endorser_only, aggregator_only)
    # Filter out the organization first based on the arguments.
    org_list = Organization.order(:slug)
    !organizations.empty? && org_list = org_list.where('organizations.id in (?)', organizations)

    if endorser_only && aggregator_only
      org_list = org_list.where(is_endorser: true)
                         .or(Organization.where(is_mni: true))
    else
      endorser_only && org_list = org_list.where(is_endorser: true)
      aggregator_only && org_list = org_list.where(is_mni: true)
    end

    !countries.empty? && org_list = org_list.joins(:locations).where('locations.id in (?)', countries)
    !sectors.empty? && org_list = org_list.joins(:sectors).where('sectors.id in (?)', sectors)
    !years.empty? && org_list = org_list.where('extract(year from when_endorsed) in (?)', years)

    if !session[:portal]['organization_views'].nil?
      if !session[:portal]['organization_views'].include?('endorser')
        org_list = org_list.where.not('is_endorser is true')
      end
      if !session[:portal]['organization_views'].include?('mni')
        org_list = org_list.where.not('is_endorser is false')
      end
      if !session[:portal]['organization_views'].include?('product')
        org_list = org_list.where
                           .not('organizations.id in (select organization_id from organizations_products)')
      end
    end
    org_list.ids
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
    logger.info 'Configuring custom registration parameters.'
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit(:email, :password, :password_confirmation, :organization_id, :role, product_id: [])
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
