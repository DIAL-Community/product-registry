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
      canEdit: can_edit,
      userToken: user.authentication_token
    }
  end
end
