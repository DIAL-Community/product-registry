class AuthenticationController < Devise::SessionsController
  acts_as_token_authentication_handler_for User, only: [:fetch_token, :invalidate_token]
  prepend_before_action :allow_params_authentication!, only: :sign_in_ux
  skip_before_action :verify_authenticity_token, only: [:sign_in_ux]

  def sign_in_ux
    user = User.find_by(email: params['user']['email'])
    if !user.valid_password?(params['user']['password'])
      respond_to do |format|
        format.json do
          render(
            json: {
              userEmail: nil,
              userName: nil,
              canEdit: false,
              userToken: nil
            },
            status: :unauthorized
          )
        end
      end
    else
      resource = warden.authenticate!(scope: :user)
      sign_in(resource, user, { session_store: true })
      can_edit = user.roles.include?('admin') || user.roles.include?('content_editor')
      respond_to do |format|
        if user.update(authentication_token: Devise.friendly_token)
          format.json do
            render(
              json: {
                userEmail: user.email,
                userName: user.username,
                canEdit: can_edit,
                userToken: user.authentication_token
              },
              status: :ok
            )
          end
        else
          format.json do
            render(
              json: {},
              status: :unauthorized
            )
          end
        end
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
end
