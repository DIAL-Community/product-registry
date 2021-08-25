class AuthenticationController < Devise::SessionsController
  acts_as_token_authentication_handler_for User, only: [:fetch_token, :invalidate_token]
  prepend_before_action :allow_params_authentication!, only: :sign_in_ux
  skip_before_action :verify_authenticity_token, only: [:sign_in_ux]

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

    resource = warden.authenticate!(scope: :user)
    sign_in(resource, user, { session_store: true })
    can_edit = user.roles.include?('admin') || user.roles.include?('content_editor')
    respond_to do |format|
      status = :unauthorized
      json = unauthorized_response
      if user.update(authentication_token: Devise.friendly_token)
        status = :ok
        json = ok_response(user, can_edit)
      end
      format.json do
        render(
          json: json,
          status: status
        )
      end
    end
  end

  def fetch_token
    user = User.find_by(email: request.headers["X-User-Email"])
    respond_to do |format|
      format.json { render(json: { userToken: user.authentication_token }) }
    end
  end

  def validate_reset_token
    reset_password_token = Devise.token_generator.digest(self, :reset_password_token, request.headers["X-User-Token"])
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
    reset_password_token = Devise.token_generator.digest(self, :reset_password_token, request.headers["X-User-Token"])
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
    user = User.find_by(email: request.headers["X-User-Email"])
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
    user = User.find_by(email: request.headers["X-User-Email"])
    user.authentication_token = Devise.friendly_token
    respond_to do |format|
      if user.save!
        format.json { render(json: { userToken: nil }, status: :ok) }
      else
        format.json { render(json: {}, status: :unprocessable_entity) }
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
      userToken: nil
    }
  end

  def ok_response(user, can_edit)
    {
      userEmail: user.email,
      userName: user.username,
      own: {
        products: user.user_products.any? ? user.user_products : [],
        organization: user.organization_id
      },
      canEdit: can_edit,
      userToken: user.authentication_token
    }
  end
end
