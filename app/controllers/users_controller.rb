class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    if params[:search]
      @users = User.where(nil)
                   .email_contains(params[:search])
                   .order(:email)
                   .paginate(page: params[:page], per_page: 20)
    else
      @users = User.order(:email)
                   .paginate(page: params[:page], per_page: 20)
    end
    authorize @users
  end

  def show
    authorize @user
  end

  def edit
    authorize @user
  end

  def new
    @user = User.new
    authorize @user
  end

  def update
    user_hash = {}
    user_hash[:role] = user_params[:role]

    user_hash[:receive_backup] = false
    if (user_params[:receive_backup]) && (user_hash[:role] == "admin")
      user_hash[:receive_backup] = user_params[:receive_backup]
    end

    if (user_params[:is_approved] && @user.confirmed_at.nil?)
      user_hash[:confirmed_at] = Time.now.to_s
    end
    respond_to do |format|
      if @user.update(user_hash)
        format.html { redirect_to @user,
                      flash: { notice: t('messages.model.updated', model: t('model.user').to_s.humanize) }}
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @user = User.new(user_params)

    if user_params[:is_approved]
      @user.confirmed_at = Time.now.to_s
    end

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user,
                      flash: { notice: t('messages.model.created', model: t('model.user').to_s.humanize) }}
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url,
                    flash: { notice: t('messages.model.deleted', model: t('model.user').to_s.humanize) }}
      format.json { head :no_content }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
      @user.is_approved = @user.confirmed_at.nil? ? false : true
    end

    def user_params
        params.require(:user)
        .permit(:email, :role, :is_approved, :confirmed_at, :password, :password_confirmation, :receive_backup)
    end
end