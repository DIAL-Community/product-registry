class ApplicationController < ActionController::Base
  include Pundit
  after_action :verify_authorized, except: :index
  helper_method :slug_em
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def slug_em(input)
    slug = input
      .split(%r{\s+})
      .map{|part| part.gsub(/[^A-Za-z]/, "").downcase}
      .join("_")
    if (slug.length > 32)
      slug = slug.slice(0, 32)
    end
    if (slug[-1] == "_")
      slug = slug.chop
    end
    return slug
  end

  def calculate_offset(first_duplicate)
    size = 1;
    if (!first_duplicate.nil?)
      size = first_duplicate.slug.delete('^0-9').to_i + 1
    end
    return size
  end
  
  private
  
  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore
    flash[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
    redirect_to(request.referrer || root_path)
  end
end
