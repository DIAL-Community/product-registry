class OrganizationsController < ApplicationController
  include OrganizationsHelper

  before_action :authenticate_user!, only: [:show, :new, :create, :edit, :update, :destroy]
  before_action :set_organization, only: [:show, :edit, :update, :destroy]

  # GET /organizations
  # GET /organizations.json
  def index
    if params[:without_paging]
      @organizations = Organization
      @organizations = params[:sector_id].nil? ? @organizations : @organizations.joins(:sectors).where("sectors.id = ?", params[:sector_id])
      @organizations = params[:search].nil? ? @organizations : @organizations.starts_with(params[:search])
      @organizations = @organizations.order(:name);
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

  def export
    export_with_params('test')
    send_file(
      "#{Rails.root}/public/export.xlsx",
      filename: "Endorsing Organizations.xlsx",
      type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    )
  end

  # GET /organizations/1
  # GET /organizations/1.json
  def show
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
  end

  # GET /organizations/1/edit
  def edit
  end

  # POST /organizations
  # POST /organizations.json
  def create

    @organization = Organization.new(organization_params)

    if (params[:selected_sectors])
      params[:selected_sectors].keys.each do |sector_id|
        @sector = Sector.find(sector_id)
        @organization.sectors.push(@sector)
      end
    end

    if (params[:selected_countries])
      params[:selected_countries].keys.each do |location_id|
        location = Location.find(location_id)
        @organization.locations.push(location)
      end
    end

    if (params[:office_id].present?)
      office = Location.find(params[:office_id])
      if (office)
        @organization.locations.push(office)
      end
    end

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

    if (params[:selected_countries])
      sectors = Set.new
      params[:selected_sectors].keys.each do |sector_id|
        sector = Sector.find(sector_id)
        sectors.add(sector)
      end
      @organization.sectors = sectors.to_a
    end

    if (params[:selected_countries])
      locations = Set.new
      params[:selected_countries].keys.each do |location_id|
        location = Location.find(location_id)
        locations.add(location)
      end
      @organization.locations = locations.to_a
    end

    if (params[:office_id])
      office = Location.find(params[:office_id])
      if (office)
        @organization.locations.push(office)
      end
    end

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
        .permit(:id, :name, :slug, :is_endorser, :when_endorsed, :website, :contact_name, :contact_email, :selected_sectors, :selected_countries, :office_id)
        .tap do |attr|
          if (attr[:when_endorsed].present?)
            attr[:when_endorsed] = Date.strptime(attr[:when_endorsed], "%m/%d/%Y")
          end
          if (attr[:name].present?)
            attr[:slug] = slug_em(attr[:name])
          end
        end
    end
end
