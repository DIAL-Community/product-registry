require 'modules/slugger'
require 'modules/constants'

class ApplicationController < ActionController::Base
  include Modules::Slugger
  include Modules::Constants
  include Pundit
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def generate_offset(first_duplicate)
    size = 1;
    if (!first_duplicate.nil?)
      size = first_duplicate
                .slug
                .slice(/_dup\d+$/)
                .delete('^0-9')
                .to_i + 1
    end
    return "_dup#{size.to_s}"
  end

  def take_filter(filter_name)
    session[filter_name.to_s]
  end

  def prepare_non_organization_filters
    non_organization_filters = {}
    OTHER_FILTER_KEYS.each do |filter|
      non_organization_filters[filter.to_s] = session[filter.to_s]
    end
    non_organization_filters
  end

  def put_non_organization_filter(filter_name, filter_value)
    return unless OTHER_FILTER_KEYS.include?(filter_name)

    session[filter_name.to_s] = filter_value
  end

  def prepare_organization_filters
    organization_filters = {}
    ORGANIZATION_FILTER_KEYS.each do |filter|
      organization_filters[filter.to_s] = session[filter.to_s]
    end
    organization_filters
  end

  def put_organization_filter(filter_name, filter_value)
    return unless ORGANIZATION_FILTER_KEYS.include?(filter_name)

    session[filter_name.to_s] = filter_value
  end

  private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore
    flash[:error] = t "#{exception.query}", scope: "pundit", default: :default
    redirect_to(request.referrer || root_path)
  end
end
