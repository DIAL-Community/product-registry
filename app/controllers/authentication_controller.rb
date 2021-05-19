class AuthenticationController < Devise::SessionsController
  prepend_before_action :allow_params_authentication!, only: :sign_in_ux
  skip_before_action :verify_authenticity_token, only: [:sign_in_ux]

  acts_as_token_authentication_handler_for User

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
    end

    respond_to do |format|
      format.json do
        render(
          json: {
            userEmail: user.email,
            userName: user.username,
            canEdit: can_edit,
            userToken: resource.authentication_token
          },
          status: :ok
        )
      end
    end
  end

  def fetch_token
    user = User.find_by(email: params['user']['email'])
    respond_to do |format|
      format.json { render(json: { auth_token: user.authentication_token }) }
    end
  end
end
