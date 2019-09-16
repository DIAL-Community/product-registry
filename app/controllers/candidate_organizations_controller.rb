class CandidateOrganizationsController < ApplicationController
  before_action :set_candidate_organization, only: [:show, :edit, :update, :destroy]

  # GET /candidate_organizations
  # GET /candidate_organizations.json
  def index
    @candidate_organizations = CandidateOrganization.all.paginate(page: params[:page], per_page: 20)
    params[:search].present? && @candidate_organizations = @candidate_organizations.name_contains(params[:search])
    authorize @candidate_organizations, :view_allowed?
  end

  # GET /candidate_organizations/1
  # GET /candidate_organizations/1.json
  def show
  end

  # GET /candidate_organizations/new
  def new
    @candidate_organization = CandidateOrganization.new
  end

  # GET /candidate_organizations/1/edit
  def edit
    authorize @candidate_organization, :mod_allowed?
  end

  # POST /candidate_organizations
  # POST /candidate_organizations.json
  def create
    # Everyone including unregistered user can post and create candidate organization.
    @candidate_organization = CandidateOrganization.new(candidate_organization_params)
    @candidate_organization.set_current_user(current_user)

    if params[:contact].present?
      contact = Contact.new
      contact.name = params[:contact][:name]
      contact.email = params[:contact][:email]
      contact.title = params[:contact][:title]

      contact.slug = slug_em(params[:contact][:name])

      dupe_count = Contact.where(slug: contact.slug).count
      if dupe_count > 0
        first_duplicate = Contact.slug_starts_with(contact.slug).order(slug: :desc).first
        contact.slug = contact.slug + generate_offset(first_duplicate).to_s
      end

      @candidate_organization.contacts.push(contact)
    end

    respond_to do |format|
      if verify_recaptcha(secret_key: Rails.application.secrets.captcha_secret_key) && @candidate_organization.save
        format.html { redirect_to @candidate_organization, notice: t('view.candidate-organization.form.created') }
        format.json { render :show, status: :created, location: @candidate_organization }
      else
        format.html { render :new }
        format.json { render json: @candidate_organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /candidate_organizations/1
  # PATCH/PUT /candidate_organizations/1.json
  def update
    authorize @candidate_organization, :mod_allowed?
    respond_to do |format|
      if @candidate_organization.update(candidate_organization_params)
        format.html { redirect_to @candidate_organization, notice: 'Candidate organization was successfully updated.' }
        format.json { render :show, status: :ok, location: @candidate_organization }
      else
        format.html { render :edit }
        format.json { render json: @candidate_organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /candidate_organizations/1
  # DELETE /candidate_organizations/1.json
  def destroy
    authorize @candidate_organization, :mod_allowed?
    @candidate_organization.destroy
    respond_to do |format|
      format.html { redirect_to candidate_organizations_url, notice: 'Candidate organization was.' }
      format.json { head :no_content }
    end
  end

  def duplicates
    @candidate_organizations = []
    if params[:current].present?
      current_slug = slug_em(params[:current]);
      original_slug = slug_em(params[:original]);
      if current_slug != original_slug
        @candidate_organizations = CandidateOrganization.where(slug: current_slug).to_a
      end
    end
    authorize @candidate_organizations, :view_allowed?
    render json: @candidate_organizations, only: [:name]
  end

  def approve
    set_candidate_organization
    authorize @candidate_organization, :mod_allowed?

    organization = Organization.new
    organization.name = @candidate_organization.name
    organization.website = @candidate_organization.website

    organization.slug = @candidate_organization.slug

    duplicates = Organization.where(slug: organization.slug)
    if duplicates.count > 0
      first_duplicate = Organization.slug_starts_with(organization.slug).order(slug: :desc).first
      organization.slug = organization.slug + generate_offset(first_duplicate).to_s
    end

    organization.contacts = @candidate_organization.contacts

    respond_to do |format|
      if organization.save && @candidate_organization.destroy
        format.html { redirect_to organization_url(organization), notice: 'Organization created.' }
        format.json { render :show, status: :created, location: @organization }
      else
        format.html { redirect_to candidate_organizations_url, notice: 'Candidate organization was not.' }
        format.json { head :no_content }
      end
    end
  end

  def reject
    set_candidate_organization
    authorize @candidate_organization, :mod_allowed?
    respond_to do |format|
      if @candidate_organization.update(rejected: true, rejected_date: Time.now, rejected_by_id: current_user.id)
        format.html { redirect_to candidate_organizations_url, notice: 'Candidate rejected.' }
      else
        format.html { redirect_to candidate_organizations_url, notice: 'Candidate rejection failed.' }
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_candidate_organization
    @candidate_organization = CandidateOrganization.find_by(slug: params[:id])
    if @candidate_organization.nil? && params[:id].scan(/\D/).empty?
      @candidate_organization = CandidateOrganization.find(params[:id])
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def candidate_organization_params
    params.require(:candidate_organization)
          .permit(:name, :slug, :website)
          .tap do |attr|
            if attr[:website].present?
              attr[:website] = attr[:website].strip
                                             .sub(/^https?\:\/\//i,'')
                                             .sub(/^https?\/\/\:/i,'')
                                             .sub(/\/$/, '')
            end
            if params[:reslug].present?
              attr[:slug] = slug_em(attr[:name])
              if params[:duplicate].present?
                first_duplicate = CandidateOrganization.slug_starts_with(attr[:slug]).order(slug: :desc).first
                attr[:slug] = attr[:slug] + generate_offset(first_duplicate).to_s
              end
            end
          end
  end
end
