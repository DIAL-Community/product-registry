class CandidateRolesController < ApplicationController
  acts_as_token_authentication_handler_for User, only: [:index, :create]
  skip_before_action :verify_authenticity_token, if: :json_request

  before_action :set_candidate_role, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :duplicate, :approve, :reject]

  def json_request
    request.format.json?
  end

  def approve
    set_candidate_role
    authorize(@candidate_role, :mod_allowed?)

    user = User.find_by(email: @candidate_role.email)
    if user.nil?
      respond_to do |format|
        format.html { redirect_to candidate_roles_url, flash: { error: 'Unable to approve request.' } }
        format.json { head :no_content }
      end
    end

    user.roles += @candidate_role.roles

    unless @candidate_role.organization_id.nil?
      user.organization_id = @candidate_role.organization_id
    end

    unless @candidate_role.product_id.nil?
      product = Product.find_by(id: @candidate_role.product_id)
      user.products << product unless product.nil?
    end

    respond_to do |format|
      # Don't re-approve approved candidate.
      if (@candidate_role.rejected.nil? || @candidate_role.rejected) &&
          user.save && @candidate_role.update(rejected: false, approved_date: Time.now,
                                              approved_by_id: current_user.id)
        format.html { redirect_to candidate_role_url(@candidate_role), notice: 'Request for elevated role approved.' }
        format.json { render :show, status: :ok, location: @candidate_role }
      else
        format.html { redirect_to candidate_roles_url, flash: { error: 'Unable to approve request.' } }
        format.json { head :no_content }
      end
    end
  end

  def reject
    set_candidate_role
    authorize(@candidate_role, :mod_allowed?)
    respond_to do |format|
      # Can only approve new submission.
      if @candidate_role.rejected.nil? &&
         @candidate_role.update(rejected: true, rejected_date: Time.now, rejected_by_id: current_user.id)
        format.html { redirect_to candidate_roles_url, notice: 'Request for elevated role rejected.' }
        format.json { render :show, status: :ok, location: @candidate_role }
      else
        format.html { redirect_to candidate_roles_url, flash: { error: 'Unable to reject request.' } }
        format.json { head :no_content }
      end
    end
  end

  # GET /candidate_roles
  # GET /candidate_roles.json
  def index
    unless policy(CandidateRole).view_allowed?
      return redirect_to(root_path)
    end

    current_page = params[:page] || 1

    if params[:search]
      @candidate_roles = CandidateRole.email_contains(params[:search])
                                      .order(:created_at)
                                      .paginate(page: current_page, per_page: 10)
    else
      @candidate_roles = CandidateRole.order(:created_at)
                                      .paginate(page: current_page, per_page: 10)
    end
    authorize(@candidate_roles, :view_allowed?)
  end

  # GET /candidate_roles/1
  # GET /candidate_roles/1.json
  def show
    authorize(@candidate_role, :view_allowed?)
    unless @candidate_role.product_id.nil?
      @product = Product.find(@candidate_role.product_id)
    end
    unless @candidate_role.organization_id.nil?
      @organization = Organization.find(@candidate_role.organization_id)
    end
  end

  # GET /candidate_roles/new
  def new
    authorize(CandidateRole, :create_allowed?)
    @candidate_role = CandidateRole.new
    unless current_user.roles.include?(User.user_roles[:admin])
      @candidate_role.email = current_user.email
    end
  end

  # GET /candidate_roles/1/edit
  def edit
    authorize(@candidate_role, :mod_allowed?)
  end

  # POST /candidate_roles
  # POST /candidate_roles.json
  def create
    session[:return_to] ||= request.referer
    @candidate_role = CandidateRole.new(candidate_role_params)

    if params[:selected_roles].present?
      params[:selected_roles].each do |selected_role|
        (@candidate_role[:roles] ||= []) << selected_role
      end
    end

    unless @candidate_role.product_id.nil?
      @candidate_role[:roles] << User.user_roles[:product_user]
    end

    unless @candidate_role.organization_id.nil?
      @candidate_role[:roles] << User.user_roles[:org_user]
    end

    respond_to do |format|
      if @candidate_role.save
        session.delete(:request_elevated_role)
        AdminMailer
          .with(user: candidate_role_params)
          .notify_ux_ownership_request
          .deliver_later
        if policy(@candidate_role).view_allowed?
          format.html { redirect_to @candidate_role, notice: 'Candidate role was successfully created.' }
        else
          format.html { redirect_to products_path, notice: 'Elevated role request submitted.' }
        end
        format.json { render(json: { message: 'Candidate role was successfully created.' }, status: :created) }
      else
        format.html { render :new }
        format.json { render(json: { message: 'Unable to process request.' }, status: :unprocessable_entity) }
      end
    end
  end

  # PATCH/PUT /candidate_roles/1
  # PATCH/PUT /candidate_roles/1.json
  def update
    authorize(@candidate_role, :mod_allowed?)

    if params[:selected_roles].present?
      params[:selected_roles].each do |selected_role|
        (@candidate_role[:roles] ||= []) << selected_role
      end
    end

    respond_to do |format|
      if @candidate_role.update(candidate_role_params)
        format.html { redirect_to @candidate_role, notice: 'Candidate role was successfully updated.' }
        format.json { render :show, status: :ok, location: @candidate_role }
      else
        format.html { render :edit }
        format.json { render json: @candidate_role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /candidate_roles/1
  # DELETE /candidate_roles/1.json
  def destroy
    authorize(@candidate_role, :mod_allowed?)
    @candidate_role.destroy
    respond_to do |format|
      format.html { redirect_to candidate_roles_url, notice: 'Candidate role was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_candidate_role
    @candidate_role = CandidateRole.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def candidate_role_params
    params.require(:candidate_role).permit(:email, :description, :product_id, :organization_id)
  end
end
