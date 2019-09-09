# Adding override for the default registration to display captcha.
class RegistrationsController < Devise::RegistrationsController
  prepend_before_action :check_captcha_and_organization, only: [:create]

  private

  def check_captcha_and_organization
    verified = verify_recaptcha secret_key: Rails.application.secrets.captcha_secret_key

    errors_messages = []
    if verified
      user_email = params[:user][:email]
      unless /\A[^@\s]+@digitalimpactalliance.org/.match?(user_email)
        organization_id = params[:user][:organization_id]
        if organization_id.strip.empty?
          logger.info 'User need to select organization to register without DIAL email.'
          errors_messages.push(I18n.translate('view.devise.organization-required'))
          verified = false
        else
          organization = Organization.find(organization_id)
          email_domain = /\A[^@\s]+@([^@\s]+\z)/.match(user_email)[1]
          logger.info "Matching organization website: '#{organization.website}' with '#{email_domain}'."
          verified = organization.website.include?(email_domain)
          verified && params[:user][:role] = User.roles[:org_user]
          !verified && errors_messages.push(I18n.translate('view.devise.organization-nomatch'))
        end
      end
    end

    unless verified
      logger.info 'Unable to verify registration.'

      configure_registration_parameters
      self.resource = resource_class.new sign_up_params
      resource.validate
      set_minimum_password_length

      # Add error messages from the organization validation above.
      !errors_messages.empty? && resource.errors.add(:organization_id, errors_messages.pop)
      respond_with_navigational(resource) { render :new }
    end
  end
end
