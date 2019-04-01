class SectorsController < ApplicationController
  before_action :set_sector, only: [:show, :edit, :update, :destroy]

  # GET /sectors
  # GET /sectors.json
  def index
    if params[:without_paging]
      @sectors = Sector
          .where(nil)
          .starts_with(params[:search])
          .order(:name)
      return
    end
    if params[:search]
      @sectors = Sector
          .where(nil)
          .starts_with(params[:search])
          .order(:name)
          .paginate(page: params[:page], per_page: 20)
    else
      @sectors = Sector
          .order(:name)
          .paginate(page: params[:page], per_page: 20)
    end
  end

  # GET /sectors/1
  # GET /sectors/1.json
  def show
  end

  # GET /sectors/new
  def new
    @sector = Sector.new
    if (params[:organization_id])
      @organization = Organization.find(params[:organization_id])
      @sector.organizations.push(@organization)
    end
  end

  # GET /sectors/1/edit
  def edit
    if (params[:organization_id])
      @organization = Organization.find(params[:organization_id])
    end
  end

  # POST /sectors
  # POST /sectors.json
  def create
    @sector = Sector.new(sector_params)

    if (params[:selected_organizations])
      params[:selected_organizations].keys.each do |organization_id|
        organization = Organization.find(organization_id)
        @sector.organizations.push(organization)
      end
    end

    respond_to do |format|
      if @sector.save
        format.html { redirect_to @sector, notice: 'Sector was successfully created.' }
        format.json { render :show, status: :created, location: @sector }
      else
        format.html { render :new }
        format.json { render json: @sector.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sectors/1
  # PATCH/PUT /sectors/1.json
  def update

    if (params[:selected_organizations])
      organizations = Set.new
      params[:selected_organizations].keys.each do |organization_id|
        organization = Organization.find(organization_id)
        organizations.add(organization)
      end
      @sector.organizations = organizations.to_a
    end

    respond_to do |format|
      if @sector.update(sector_params)
        format.html { redirect_to @sector, notice: 'Sector was successfully updated.' }
        format.json { render :show, status: :ok, location: @sector }
      else
        format.html { render :edit }
        format.json { render json: @sector.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sectors/1
  # DELETE /sectors/1.json
  def destroy
    @sector.destroy
    respond_to do |format|
      format.html { redirect_to sectors_url, notice: 'Sector was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sector
      @sector = Sector.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sector_params
      params.require(:sector).permit(:name, :slug)
    end
end
