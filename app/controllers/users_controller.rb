class UsersController < ApplicationController
  acts_as_token_authentication_handler_for User, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def statistics
    if current_user.nil?
      return respond_to do |format|
        format.html { redirect_to users_url }
        format.json { render json: {}, status: :unauthorized }
      end
    end

    end_date = Date.today + 1
    start_date = end_date.last_month

    if params[:end_date].present?
      end_date = Date.strptime(params[:end_date], '%m/%d/%Y') + 1
    end

    if params[:start_date].present?
      start_date = Date.strptime(params[:start_date], '%m/%d/%Y')
    end

    @number_distinct_user = UserEvent.group(:identifier)
                                     .where('event_datetime BETWEEN ? AND ?', start_date, end_date)
                                     .select('identifier, count(identifier) as count')
                                     .order('COUNT(user_events.identifier) DESC')
                                     .first

    @number_login_user =  UserEvent.where.not(email: nil)
                                   .where('event_datetime BETWEEN ? AND ?', start_date, end_date)
                                   .select('email, count(email) as count')
                                   .group(:email)
                                   .order('COUNT(user_events.email) DESC')
                                   .first

    @most_visited_product = UserEvent.where(event_type: UserEvent.event_types[:product_view])
                                     .where('event_datetime BETWEEN ? AND ?', start_date, end_date)
                                     .select("extended_data -> 'name' as product_name")
                                     .each_with_object({}) do |element, count|
                                       if count[element.product_name].nil?
                                         count[element.product_name] = 0
                                       end
                                       count[element.product_name] += 1
                                     end
                                     .sort_by { |_k, v| v }
                                     .reverse
                                     .first

    @most_recorded_event = UserEvent.select('event_type, count(event_type) as count')
                                    .where('event_datetime BETWEEN ? AND ?', start_date, end_date)
                                    .group(:event_type)
                                    .order('COUNT(user_events.event_type) DESC')
                                    .first

    @user_events = UserEvent.all
    if params[:search].present?
      @user_events = @user_events.where('email like ? or identifier like ?',
                                        "%#{params[:search]}%", "%#{params[:search]}%")
    end

    @user_events = @user_events.where('event_datetime BETWEEN ? AND ?', start_date, end_date)
                               .order(event_datetime: :desc)
                               .paginate(page: params[:page], per_page: 20)
  end

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
    if params[:selected_roles].present?
      params[:selected_roles].each do |selected_role|
        (user_hash[:roles] ||= []) << selected_role
      end
    end

    user_hash[:receive_backup] = false
    user_hash[:receive_admin_emails] = false
    if user_hash[:roles].include?(User.user_roles[:admin])
      if user_params[:receive_backup].present?
        user_hash[:receive_backup] = user_params[:receive_backup]
      end
      if user_params[:receive_admin_emails].present?
        user_hash[:receive_admin_emails] = user_params[:receive_admin_emails]
      end
    end

    if user_params[:is_approved].present? && @user.confirmed_at.nil?
      user_hash[:confirmed_at] = Time.now.to_s
      # If this user registered to be a product owner and was just approved, send an email to them
      send_notification(@user.email)
    end

    user_hash[:products] = []
    if user_hash[:roles].include?(User.user_roles[:product_user])
      products = Set.new
      if params[:selected_products].present?
        params[:selected_products].keys.each do |product_id|
          product = Product.find(product_id)
          products.add(product) unless product.nil?
        end
      end
      user_hash[:products] = products.to_a
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

  def export_data
    @user = User.all
    authorize(@user, :show?)
    respond_to do |format|
      format.csv do
        render csv: @user, filename: 'exported-users'
      end
      format.json do
        render json: @user.to_json(User.serialization_options)
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
    @user.is_approved = !@user.confirmed_at.nil?
  end

  def user_params
    params.require(:user)
          .permit(:email, :username, :is_approved, :confirmed_at, :password, :password_confirmation,
                  :receive_backup, :receive_admin_emails)
  end

  def send_notification(user_email)
    AdminMailer
      .with(user_email: user_email)
      .notify_product_owner_approval
      .deliver_later
  end
end