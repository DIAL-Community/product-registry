# frozen_string_literal: true

class AuthenticationController < Devise::SessionsController
  acts_as_token_authentication_handler_for User, only: %i[fetch_token invalidate_token]
  prepend_before_action :allow_params_authentication!, only: %i[sign_in_ux sign_in_auth0]
  skip_before_action :verify_authenticity_token, only: %i[sign_in_ux sign_in_auth0]

  def sign_up_ux
    user = User.new(user_params)
    respond_to do |format|
      if verify_recaptcha(secret_key: Rails.application.secrets.captcha_secret_key) && user.save
        format.json { render(json: {}, status: :created) }
      else
        format.json { render(json: user.errors, status: :unprocessable_entity) }
      end
    end
  end

  def sign_in_ux
    user = User.find_by(email: params['user']['email'])
    unless user.valid_password?(params['user']['password'])
      respond_to do |format|
        format.json do
          render(
            json: unauthorized_response,
            status: :unauthorized
          )
        end
      end
    end

    sign_in(user, store: true)
    respond_to do |format|
      status = :unauthorized
      json = unauthorized_response
      if user.update(authentication_token: Devise.friendly_token)
        organization = Organization.find(user.organization_id) if user.organization_id
        can_edit = user.roles.include?('admin') || user.roles.include?('content_editor')
        status = :ok
        json = ok_response(user, can_edit, organization)
      end
      format.json do
        render(
          json: json,
          status: status
        )
      end
    end
  end

  def sign_in_auth0
    user = User.find_by(email: params['user']['email'])

    if user.nil?
      respond_to do |format|
        status = :ok
        json = new_user_response(params['user']['email'])
        format.json do
          render(
            json: json,
            status: status
          )
        end
      end
    else
      sign_in(user, store: true)
      can_edit = user.roles.include?('admin') || user.roles.include?('content_editor')
      organization = Organization.find(user.organization_id) if user.organization_id
      respond_to do |format|
        status = :unauthorized
        json = unauthorized_response
        if user.update(authentication_token: Devise.friendly_token)
          status = :ok
          json = ok_response(user, can_edit, organization)
        end
        format.json do
          render(
            json: json,
            status: status
          )
        end
      end
    end
  end

  def fetch_token
    user = User.find_by(email: request.headers['X-User-Email'])
    respond_to do |format|
      format.json { render(json: { userToken: user.authentication_token }) }
    end
  end

  def validate_reset_token
    reset_password_token = Devise.token_generator.digest(self, :reset_password_token, request.headers['X-User-Token'])
    user = User.find_by(reset_password_token: reset_password_token)
    respond_to do |format|
      if user.nil?
        format.json { render(json: { message: 'Invalid reset token.' }, status: :unprocessable_entity) }
      else
        format.json { render(json: { message: 'Valid reset token.' }, status: :ok) }
      end
    end
  end

  def apply_reset_token
    reset_password_token = Devise.token_generator.digest(self, :reset_password_token, request.headers['X-User-Token'])
    user = User.find_by(reset_password_token: reset_password_token)
    if user.nil?
      # User is not in the database based on the email address.
      respond_to do |format|
        format.json { render(json: { message: 'Invalid reset token.' }, status: :unprocessable_entity) }
      end
    end

    user = User.reset_password_by_token(reset_password_params)
    respond_to do |format|
      if user.errors.none?
        format.json { render(json: { message: 'Password updated.' }, status: :ok) }
      else
        format.json { render(json: { message: 'Please try again.' }, status: :bad_request) }
      end
    end
  end

  def reset_password
    user = User.find_by(email: request.headers['X-User-Email'])
    if user.nil?
      # User is not in the database based on the email address.
      respond_to do |format|
        format.json { render(json: { message: 'Invalid email address.' }, status: :unprocessable_entity) }
      end
    else
      # User is found, initiate the reset password workflow.
      token = user.send_reset_password_instructions
      respond_to do |format|
        if !token.nil?
          format.json { render(json: { message: 'Instruction emailed.' }, status: :created) }
        else
          format.json { render(json: { message: 'Please try again.' }, status: :ok) }
        end
      end
    end
  end

  def invalidate_token
    user = User.find_by(email: request.headers['X-User-Email'])
    if user.nil?
      respond_to do |format|
        format.json { render(json: { userToken: nil }, status: :ok) }
      end
    else
      user.authentication_token = Devise.friendly_token
      respond_to do |format|
        if user.save!
          format.json { render(json: { userToken: nil }, status: :ok) }
        else
          format.json { render(json: {}, status: :unprocessable_entity) }
        end
      end
    end
  end

  private

  def user_params
    params.require(:user)
          .permit(:email, :username, :password, :password_confirmation, :organization_id, user_products: [])
  end

  def reset_password_params
    params.require(:user)
          .permit(:reset_password_token, :password, :password_confirmation)
  end

  def unauthorized_response
    {
      userEmail: nil,
      userName: nil,
      canEdit: false,
      roles: nil,
      userToken: nil
    }
  end

  def ok_response(user, can_edit, organization)
    {
      userEmail: user.email,
      name: user.username,
      own: {
        products: user.products.any? ? user.products.map(&:id) : [],
        organization: organization
      },
      canEdit: can_edit,
      roles: user.roles,
      userToken: user.authentication_token
    }
  end

  def new_user_response(email)
    {
      userEmail: email,
      userName: email
    }
  end
end
