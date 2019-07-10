class LocationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  # GET /locations
  # GET /locations.json
  def index
    if params[:without_paging]
      @locations = Location
          .where.not(location_type: 'point')
          .name_contains(params[:search])
          .order(:name)
      authorize @locations, :view_allowed?
      return
    end

    if params[:office_only]
      @locations = Location
          .where(location_type: 'point')
          .name_contains(params[:search])
          .order(:name)
      authorize @locations, :view_allowed?
      return
    end

    if params[:search]
      @locations = Location
          .where.not(location_type: 'point')
          .name_contains(params[:search])
          .order(:name)
          .paginate(page: params[:page], per_page: 20)
      authorize @locations, :view_allowed?
    else
      @locations = Location
          .where.not(location_type: 'point')
          .order(:name)
          .paginate(page: params[:page], per_page: 20)
      authorize @locations, :view_allowed?
    end
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
    authorize @location, :view_allowed?
  end

  # GET /locations/new
  def new
    authorize Location, :mod_allowed?
    @location = Location.new
    if (params[:organization_id])
      @organization = Organization.find(params[:organization_id])
      @location.organizations.push(@organization)
    end
  end

  # GET /locations/1/edit
  def edit
    authorize @location, :mod_allowed?
    if (params[:organization_id])
      @organization = Organization.find(params[:organization_id])
    end
  end

  # POST /locations
  # POST /locations.json
  def create
    authorize Location, :mod_allowed?
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
        format.html { redirect_to @location, flash: { notice: 'Location was successfully created.' }}
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
    authorize @location, :mod_allowed?
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
        format.html { redirect_to @location, flash: { notice: 'Location was successfully updated.' }}
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
    authorize @location, :mod_allowed?
    @location.destroy
    respond_to do |format|
      format.html { redirect_to locations_url, flash: { notice: 'Location was successfully destroyed.' }}
      format.json { head :no_content }
    end
  end

  def duplicates
    @locations = Array.new
    if params[:current].present?
      current_slug = slug_em(params[:current]);
      original_slug = slug_em(params[:original]);
      if (current_slug != original_slug)
        @locations = Location.where(slug: current_slug).to_a
      end
    end
    authorize @locations, :view_allowed?
    render json: @locations, :only => [:name]
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
        .permit(:name, :confirmation)
        .tap do |attr|
          if (params[:reslug].present?)
            attr[:slug] = slug_em(attr[:name])
            if (params[:duplicate].present?)
              first_duplicate = Location.slug_starts_with(attr[:slug]).order(slug: :desc).first
              attr[:slug] = attr[:slug] + "_" + calculate_offset(first_duplicate).to_s
            end
          end
        end
    end
end
