class OrganizationsController < ApplicationController
  # before_action :authenticate_user!, only: [:edit, :update, :destroy]
  before_action :set_organization, only: [:show, :edit, :update, :destroy]
  # before_action :set_relations, only: [:edit]

  # GET /organizations
  # GET /organizations.json
  def index
    if params[:without_paging]
      @organizations = Organization.all
      return
    end
    if params[:search]
      @organizations = Organization
          .where(nil)
          .starts_with(params[:search])
          .order(:name)
          .paginate(page: params[:page], per_page: 20)
    else
      @organizations = Organization
          .order(:name)
          .paginate(page: params[:page], per_page: 20)
    end
  end

  # GET /organizations/1
  # GET /organizations/1.json
  def show
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
    @organization.sectors.build
  end

  # GET /organizations/1/edit
  def edit
  end

  # POST /organizations
  # POST /organizations.json
  def create
    @organization = Organization.new(organization_params)

    respond_to do |format|
      if @organization.save
        format.html { redirect_to @organization, notice: 'Organization was successfully created.' }
        format.json { render :show, status: :created, location: @organization }
      else
        format.html { render :new }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organizations/1
  # PATCH/PUT /organizations/1.json
  def update
    respond_to do |format|
      if @organization.update(organization_params)
        format.html { redirect_to @organization, notice: 'Organization was successfully updated.' }
        format.json { render :show, status: :ok, location: @organization }
      else
        format.html { render :edit }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.json
  def destroy
    @organization.destroy
    respond_to do |format|
      format.html { redirect_to organizations_url, notice: 'Organization was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def map
    @organizations = Organization.eager_load(:locations)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = Organization.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organization_params
      params
        .require(:organization)
        .permit(:id, :name, :slug, :is_endorser, :when_endorsed, :website, :contact_name, :contact_email, :selected_sectors)
        .tap do |attr|
          attr[:when_endorsed] = Date.strptime(attr[:when_endorsed], "%m/%d/%Y")
        end
    end
end
