require 'modules/slugger'
require 'modules/constants'

class ApplicationController < ActionController::Base
  include Modules::Slugger
  include Modules::Constants
  include Pundit
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

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
        session.delete(curr_filter['filter_name'])
      end
    end
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

  private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore
    flash[:error] = t "#{exception.query}", scope: "pundit", default: :default
    redirect_to(request.referrer || root_path)
  end
end
