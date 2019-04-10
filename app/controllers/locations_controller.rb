class LocationsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  # GET /locations
  # GET /locations.json
  def index
    if params[:without_paging]
      @locations = Location
          .where.not(location_type: 'point')
          .starts_with(params[:search])
          .order(:name)
      return
    end

    if params[:office_only]
      @locations = Location
          .where(location_type: 'point')
          .starts_with(params[:search])
          .order(:name)
      return
    end

    if params[:search]
      @locations = Location
          .where.not(location_type: 'point')
          .starts_with(params[:search])
          .order(:name)
          .paginate(page: params[:page], per_page: 20)
    else
      @locations = Location
          .where.not(location_type: 'point')
          .order(:name)
          .paginate(page: params[:page], per_page: 20)
    end
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
  end

  # GET /locations/new
  def new
    @location = Location.new
    if (params[:organization_id])
      @organization = Organization.find(params[:organization_id])
      @location.organizations.push(@organization)
    end
  end

  # GET /locations/1/edit
  def edit
    if (params[:organization_id])
      @organization = Organization.find(params[:organization_id])
    end
  end

  # POST /locations
  # POST /locations.json
  def create
    @location = Location.new(location_params)
    @location.location_type = 'country'

    if (params[:selected_organizations])
      params[:selected_organizations].keys.each do |organization_id|
        organization = Organization.find(organization_id)
        @location.organizations.push(organization)
      end
    end

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: 'Location was successfully created.' }
        format.json { render :show, status: :created, location: @location }
      else
        format.html { render :new }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locations/1
  # PATCH/PUT /locations/1.json
  def update

    if (params[:selected_organizations])
      organizations = Set.new
      params[:selected_organizations].keys.each do |organization_id|
        organization = Organization.find(organization_id)
        organizations.add(organization)
      end
      @location.organizations = organizations.to_a
    end

    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to @location, notice: 'Location was successfully updated.' }
        format.json { render :show, status: :ok, location: @location }
      else
        format.html { render :edit }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location.destroy
    respond_to do |format|
      format.html { redirect_to locations_url, notice: 'Location was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
      params
        .require(:location)
        .permit(:name)
        .tap do |attr|
          if (attr[:name].present?)
            attr[:slug] = slug_em(attr[:name])
          end
        end
    end
end
