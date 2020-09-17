class CandidateRolesController < ApplicationController
  before_action :set_candidate_role, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :duplicate, :approve, :reject]

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
    authorize(@candidate_role, :create_allowed?)

    if params[:selected_roles].present?
      params[:selected_roles].each do |selected_role|
        (@candidate_role[:roles] ||= []) << selected_role
      end
    end

    respond_to do |format|
      if @candidate_role.save
        session.delete(:request_elevated_role)
        if policy(@candidate_role).view_allowed?
          format.html { redirect_to @candidate_role, notice: 'Candidate role was successfully created.' }
          format.json { render :show, status: :created, location: @candidate_role }
        else
          format.html { redirect_to products_path, notice: 'Elevated role request submitted.' }
        end
      else
        format.html { render :new }
        format.json { render json: @candidate_role.errors, status: :unprocessable_entity }
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
    params.require(:candidate_role).permit(:email, :roles, :description)
  end
end
