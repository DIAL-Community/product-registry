# Adding override for the default registration to display captcha.
class RegistrationsController < Devise::RegistrationsController
  prepend_before_action :check_captcha, only: [:create]

  private

  def check_captcha
    unless verify_recaptcha secret_key: Rails.application.secrets.captcha_secret_key
      logger.info 'Unable to verify registration.'

      configure_registration_parameters
      self.resource = resource_class.new sign_up_params
      resource.validate
      set_minimum_password_length

      respond_with_navigational(resource) { render :new }
    end
  end
end
