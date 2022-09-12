# frozen_string_literal: true

# Adding override for the default registration to display captcha.
class RegistrationsController < Devise::RegistrationsController
  after_action :send_notification, only: [:create]

  # Overriding how devise build the user object here.
  def build_resource(hash = {})
    if hash[:product_id].present?
      products = []
      hash[:product_id].each do |product_id|
        product = Product.find(product_id)
        products.push(product.id) unless product.nil?
      end
      hash[:user_products] = products
    end
    self.resource = resource_class.new_with_session(hash.except(:product_id), session)
  end

  private

  def send_notification
    AdminMailer
      .with(user: sign_up_params)
      .notify_product_owner_request
      .deliver_later
  end
end
