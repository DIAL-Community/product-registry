require 'modules/slugger'
require 'modules/constants'

class ApplicationController < ActionController::Base
  include Modules::Slugger
  include Modules::Constants
  include Pundit
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :configure_registration_parameters, if: :devise_controller?

  def generate_offset(first_duplicate)
    size = 1
    if (!first_duplicate.nil?)
      size = first_duplicate
                .slug
                .slice(/_dup\d+$/)
                .delete('^0-9')
                .to_i + 1
    end
    return "_dup#{size.to_s}"
  end

  def update_cookies(filter_name)
    case filter_name
    when 'products', 'origins', 'with_maturity_assessment'
      cookies[:updated_prod_filter] = true
    end
  end

  def remove_filter
    return unless params.key? 'filter_array'

    filter_array = params['filter_array']
    filter_array.each do | filter_item |
      curr_filter = filter_array[filter_item]
      filter_name = curr_filter['filter_name']
      if curr_filter['filter_value']
        filter_obj = Hash.new
        filter_obj['value'] = curr_filter['filter_value']
        filter_obj['label'] = curr_filter['filter_label']
        existing_value = session[filter_name.to_s]
        existing_value.delete(filter_obj)
        existing_value.empty? && session.delete(filter_name.to_s)
        !existing_value.empty? && session[filter_name.to_s] = existing_value
      else
        filter_obj = Hash.new
        existing_value = session[filter_name.to_s]
        existing_value && existing_value.delete(filter_obj)
        session.delete(filter_name.to_s)
      end
      update_cookies(filter_name)
    end

    render json: true
  end

  def add_filter
    return unless params.key? 'filter_name'

    retval = false
    filter_name = params['filter_name']
    filter_obj = Hash.new
    filter_obj['value'] = params['filter_value']
    filter_obj['label'] = params['filter_label']
    if params['filter_label'].nil? || params['filter_label'].empty?
      session[filter_name.to_s] = filter_obj
      retval = true
    else
      existing_value = session[filter_name.to_s]
      existing_value.nil? && existing_value = []
      if (!existing_value.include? filter_obj)
        existing_value.push(filter_obj)
        retval = true
      end
      session[filter_name.to_s] = existing_value
    end
    update_cookies(filter_name)
    render json: retval
  end

  def get_filters
    filters = Hash.new
    ORGANIZATION_FILTER_KEYS.each do |key|
      if session[key]
        filters[key] = session[key]
      end
    end
    FRAMEWORK_FILTER_KEYS.each do |key|
      if session[key]
        filters[key] = session[key]
      end
    end
    render json: filters
  end

  def sanitize_filter_values(filter_name)
    filter_values = []
    (params.key? filter_name.to_s) && filter_values += params[filter_name.to_s].reject { |value| value.nil? || value.blank? }
    filter_values
  end

  def sanitize_filter_value(filter_name)
    filter_value = nil
    (params.key? filter_name.to_s) && filter_value = params[filter_name.to_s]
    filter_value
  end

  def sanitize_session_values(filter_name)
    filter_values = []
    if (session.key? filter_name.to_s)
      session[filter_name.to_s].each do |curr_filter|
        filter_values.push(curr_filter['value'])
      end
    end
    filter_values
  end

  def sanitize_session_value(filter_name)
    filter_value = nil
    (session.key? filter_name.to_s) && filter_value = session[filter_name.to_s]
    filter_value
  end

  def get_products_from_filters(products, origins, with_maturity_assessment)
    # Check to see if the filter has already been set
    if cookies[:updated_prod_filter].nil? || cookies[:updated_prod_filter] == 'true'
      filter_products = Product.all
      if !products.empty?
        filter_products = Product.all.where('id in (?)', products)
      end

      if !origins.empty?
        filter_products = filter_products.where('id in (select product_id from products_origins where origin_id in (?))', origins)
      end

      if with_maturity_assessment
        filter_products = filter_products.where('id in (select product_id from product_assessments where has_osc = true or has_digisquare = true)')
      end

      product_filter_set = false
      if !products.empty? || !origins.empty? || with_maturity_assessment
        product_filter_set = true
      end

      product_list = filter_products.ids
      # Set the cookies for caching
      cookies[:updated_prod_filter] = false
      cookies[:filter_products] = product_list.join(',')
      cookies[:prod_filter_set] = product_filter_set
    else
      product_filter_set = cookies[:prod_filter_set]
      product_list = cookies[:filter_products].split(",").map(&:to_i)
    end
    return product_list, product_filter_set
  end

  def get_use_cases_from_workflows(workflows)
    if !workflows.empty?
      workflow_use_cases = UseCase.all.where('id in (select use_case_id from workflows_use_cases where workflow_id in (?))', workflows)
    else
      workflow_use_cases = UseCase.all
    end
    workflow_use_cases.ids
  end

  def get_use_cases_from_bbs(bbs)
    if !bbs.empty?
      bb_workflows = Workflow.all.where('id in (select workflow_id from workflows_building_blocks where building_block_id in (?))', bbs)
      bb_use_cases = UseCase.all.where('id in (select use_case_id from workflows_use_cases where workflow_id in (?))', bb_workflows.ids)
    else
      bb_use_cases = UseCase.all
    end
    bb_use_cases.ids
  end

  def get_use_cases_from_sdgs(sdgs)
    if !sdgs.empty?
      sdg_targets = SdgTarget.all.where('sdg_number in (?)', sdgs)
      sdg_use_cases = UseCase.all.where('id in (select use_case_id from use_cases_sdg_targets where sdg_target_id in (?))', sdg_targets.ids)
    else
      sdg_use_cases = UseCase.all
    end
    sdg_use_cases.ids
  end

  def get_workflows_from_use_cases(use_cases)
    if !use_cases.empty?
      workflow_use_cases = Workflow.all.where('id in (select workflow_id from workflows_use_cases where use_case_id in (?))', use_cases)
    else
      workflow_use_cases = Workflow.all
    end
    workflow_use_cases.ids
  end

  def get_workflows_from_sdgs(sdgs)
    if !sdgs.empty?
      sdg_targets = SdgTarget.all.where('sdg_number in (?)', sdgs)
      sdg_use_cases = UseCase.all.where('id in (select use_case_id from use_cases_sdg_targets where sdg_target_id in (?))', sdg_targets.ids)
      workflow_sdgs = Workflow.all.where('id in (select workflow_id from workflows_use_cases where use_case_id in (?))', sdg_use_cases.ids)
    else
      workflow_sdgs = Workflow.all
    end
    workflow_sdgs.ids
  end

  def get_workflows_from_bbs(bbs)
    if !bbs.empty?
      workflow_bbs = Workflow.all.where('id in (select workflow_id from workflows_building_blocks where building_block_id in (?))', bbs)
    else
      workflow_bbs = Workflow.all
    end
    workflow_bbs.ids
  end

  def get_workflows_from_products(products, filters_set)
    if (filters_set)
      product_bbs = BuildingBlock.all.where('id in (select building_block_id from products_building_blocks where product_id in (?))', products)
      product_workflows = Workflow.all.where('id in (select workflow_id from workflows_building_blocks where building_block_id in (?))', product_bbs.ids)
    else
      product_workflows = Workflow.all
    end
    product_workflows.ids
  end

  def get_bbs_from_use_cases(use_cases)
    if !use_cases.empty?
      use_case_workflows = Workflow.all.where('id in (select workflow_id from workflows_use_cases where use_case_id in (?))', use_cases)
      use_case_bbs = BuildingBlock.all.where('id in (select building_block_id from workflows_building_blocks where workflow_id in (?))', use_case_workflows.ids)
    else
      use_case_bbs = BuildingBlock.all
    end
    use_case_bbs.ids
  end

  def get_bbs_from_workflows(workflows)
    if !workflows.empty?
      workflow_bbs = BuildingBlock.all.where('id in (select building_block_id from workflows_building_blocks where workflow_id in (?))', workflows)
    else
      workflow_bbs = BuildingBlock.all
    end
    workflow_bbs.ids
  end

  def get_bbs_from_products(products, filters_set)
    if filters_set == true
      product_bbs = BuildingBlock.all.where('id in (select building_block_id from products_building_blocks where product_id in (?))', products)
    else
      product_bbs = BuildingBlock.all
    end
    product_bbs.ids
  end

  protected

  def configure_registration_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role, :organization])
  end

  private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore
    flash[:error] = t "#{exception.query}", scope: "pundit", default: :default
    redirect_to(request.referrer || root_path)
  end
end
