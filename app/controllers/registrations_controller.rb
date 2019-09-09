# Adding override for the default registration to display captcha.
class RegistrationsController < Devise::RegistrationsController
  prepend_before_action :check_captcha_and_organization, only: [:create]

  private

  def check_captcha_and_organization
    verified = verify_recaptcha secret_key: '6LcJcbcUAAAAAIf48XvFsFC8As_YLUp13FhjNLS4'

    if verified
      user_email = params[:user][:email]
      unless /\A[^@\s]+@digitalimpactalliance.org/.match?(user_email)
        organization_id = params[:organization]
        if organization_id.strip.empty?
          logger.info 'User need to select organization to register without DIAL email.'
          verified = false
        else
          organization = Organization.find(organization_id)
          email_domain = /\A[^@\s]+@([^@\s]+\z)/.match(user_email)[1]
          logger.info "Matching organization website: '#{organization.website}' with '#{email_domain}'."
          verified = organization.website.include?(email_domain)
          verified && params['role'] = 'org_user'
        end
      end
    end

    unless verified
      logger.info 'Unable to verify registration.'
      self.resource = resource_class.new sign_up_params
      resource.validate
      set_minimum_password_length
      respond_with_navigational(resource) { render :new, errors: {} }
    end
  end
end
