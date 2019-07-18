class ApplicationController < ActionController::Base
  include Pundit
  helper_method :slug_em
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def slug_em(input)
    slug = input
      .split(%r{\s+})
      .map{|part| part.gsub(/[^A-Za-z0-9]/, "").downcase}
      .join("_")
    if (slug.length > 32)
      slug = slug.slice(0, 32)
    end
    if (slug[-1] == "_")
      slug = slug.chop
    end
    return slug
  end

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
  
  private
  
  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore
    flash[:error] = t "#{exception.query}", scope: "pundit", default: :default
    redirect_to(request.referrer || root_path)
  end
end
