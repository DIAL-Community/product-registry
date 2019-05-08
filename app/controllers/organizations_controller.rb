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
      @organizations = params[:search].nil? ? @organizations : @organizations.name_contains(params[:search])
      @organizations = @organizations.order(:name);
      return
    end
    if params[:search]
      @organizations = Organization
          .where(nil)
          .name_contains(params[:search])
          .order(:name)
          .paginate(page: params[:page], per_page: 20)
    else
      @organizations = Organization
          .order(:slug)
          #.paginate(page: params[:page], per_page: 20)
    end
  end

  def export
    export_with_params('test')
    send_file(
      "#{Rails.root}/public/export.xls",
      filename: "Endorsing Organizations.xls",
      type: "application/vnd.ms-excel"
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

    if (params[:selected_sectors].present?)
      params[:selected_sectors].keys.each do |sector_id|
        @sector = Sector.find(sector_id)
        @organization.sectors.push(@sector)
      end
    end

    if (params[:selected_countries].present?)
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

    if (params[:office_magickey].present?)
      auth_token = authenticate_user
      geocoded_location = geocode(params[:office_magickey], auth_token)
      geocoded_location.save
      @organization.locations.push(geocoded_location)
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

    if (params[:selected_sectors].present?)
      sectors = Set.new
      params[:selected_sectors].keys.each do |sector_id|
        sector = Sector.find(sector_id)
        sectors.add(sector)
      end
      @organization.sectors = sectors.to_a
    end

    locations = Set.new
    if (params[:selected_countries].present?)
      params[:selected_countries].keys.each do |location_id|
        location = Location.find(location_id)
        locations.add(location)
      end
    end

    if (params[:office_id].present?)
      office = Location.find(params[:office_id])
      if (office and @organization.locations.where(slug: office.slug).empty?)
        locations.add(office)
      end
    end

    if (params[:office_magickey].present?)
      auth_token = authenticate_user
      geocoded_location = geocode(params[:office_magickey], auth_token)
      geocoded_location.save
      locations.add(geocoded_location)
    end

    @organization.locations = locations.to_a

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

  def duplicates
    @organizations = Array.new
    if params[:current].present?
      current_slug = slug_em(params[:current]);
      original_slug = slug_em(params[:original]);
      if (current_slug != original_slug)
        @organizations = Organization.where(slug: current_slug).to_a
      end
    end
    render json: @organizations, :only => [:name]
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = Organization.find(params[:id])
    end

    def authenticate_user
      uri = URI.parse(Rails.configuration.geocode["esri"]["auth_uri"])
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(uri.path)
      data = {"client_id" => Rails.configuration.geocode["esri"]["client_id"],
          "client_secret" => Rails.configuration.geocode["esri"]["client_secret"],
          "grant_type" => Rails.configuration.geocode["esri"]["grant_type"]}
      request.set_form_data(data);

      response = http.request(request)
      response_json = JSON.parse(response.body)
      response_json["access_token"]
    end

    def geocode(magic_key, auth_token)
      uri_template = Addressable::Template.new(Rails.configuration.geocode["esri"]["geocode_uri"])
      geocode_uri = uri_template.expand({
        "q" => {
          "SingleLine" => magic_key,
          "magicKey" => magic_key,
          "token" => auth_token,
          "f" => "json",
          "forStorage" => "true"
        }
      })

      uri = URI.parse(geocode_uri)
      response = Net::HTTP.post_form(uri, {})

      location_data = JSON.parse(response.body)
      location_name = location_data["candidates"][0]["address"]
      location_slug = slug_em(location_name)
      location_x = location_data["candidates"][0]["location"]["x"]
      location_y = location_data["candidates"][0]["location"]["y"]

      Location.new(name: location_name, slug: location_slug, :location_type => :point,
          points: [ActiveRecord::Point.new(location_y, location_x)])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organization_params
      params
        .require(:organization)
        .permit(:id, :name, :is_endorser, :when_endorsed, :website, :contact_name, :contact_email,
                :selected_sectors, :selected_countries, :office_id, :office_magickey, :confirmation)
        .tap do |attr|
          if (attr[:when_endorsed].present?)
            attr[:when_endorsed] = Date.strptime(attr[:when_endorsed], "%m/%d/%Y")
          end
          if (params[:reslug].present?)
            attr[:slug] = slug_em(attr[:name])
            if (params[:duplicate].present?)
              first_duplicate = Organization.slug_starts_with(attr[:slug]).order(slug: :desc).first
              attr[:slug] = attr[:slug] + "_" + calculate_offset(first_duplicate).to_s
            end
          end
        end
    end
end
