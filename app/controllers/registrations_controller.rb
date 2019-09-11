# Adding override for the default registration to display captcha.
class RegistrationsController < Devise::RegistrationsController
  prepend_before_action :check_captcha, only: [:create]

  # Overriding how devise build the user object here.
  def build_resource(hash = {})
    if hash[:product_id].present?
      products = []
      hash[:product_id].each do |product_id|
        product = Product.find(product_id)
        !product.nil? && products.push(product)
      end
      hash[:products] = products
    end
    self.resource = resource_class.new_with_session(hash, session)
  end

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
