class AuthenticationController < ApplicationController
  def sign_in
    @user = User.find_by(email: params['username'])
    if !@user.valid_password?(params['password'])
      @user = nil
    else
      can_edit = @user.roles.include?('admin') || @user.roles.include?('content_editor')
    end

    respond_to do |format|
      format.json { render json: { email: @user.email, 'can_edit': can_edit } }
    end
  end
end