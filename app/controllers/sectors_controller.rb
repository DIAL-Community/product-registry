class SectorsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_sector, only: [:show, :edit, :update, :destroy]

  def unique_search
    record = Sector.find_by(slug: params[:id])
    if record.nil?
      return render(json: {}, status: :not_found)
    end

    render(json: record.to_json(Sector.serialization_options
                                      .merge({
                                        item_path: request.original_url,
                                        include_relationships: true
                                      })))
  end

  def simple_search
    default_page_size = 20
    sectors = Sector.order(:slug)

    current_page = 1
    if params[:page].present? && params[:page].to_i > 0
      current_page = params[:page].to_i
    end

    if params[:search].present?
      sectors = sectors.name_contains(params[:search])
    end

    sectors = sectors.paginate(page: current_page, per_page: default_page_size)

    results = {
      url: request.original_url,
      count: sectors.count,
      page_size: default_page_size
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if sectors.count > default_page_size * current_page
      query["page"] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = URI.decode(uri.to_s)
    end

    if current_page > 1
      query["page"] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = URI.decode(uri.to_s)
    end

    results['results'] = sectors

    uri.fragment = uri.query = nil
    render(json: results.to_json(Sector.serialization_options
                                       .merge({
                                         collection_path: uri.to_s,
                                         include_relationships: true
                                       })))
  end

  def complex_search
    default_page_size = 20
    sectors = Sector.order(:slug)

    current_page = 1
    if params[:page].present? && params[:page].to_i > 0
      current_page = params[:page].to_i
    end

    if params[:search].present?
      sectors = sectors.name_contains(params[:search])
    end

    sectors = sectors.paginate(page: current_page, per_page: default_page_size)

    results = {
      url: request.original_url,
      count: sectors.count,
      page_size: default_page_size
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if sectors.count > default_page_size * current_page
      query["page"] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = URI.decode(uri.to_s)
    end

    if current_page > 1
      query["page"] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = URI.decode(uri.to_s)
    end

    results['results'] = sectors

    uri.fragment = uri.query = nil
    render(json: results.to_json(Sector.serialization_options
                                       .merge({
                                         collection_path: uri.to_s,
                                         include_relationships: true
                                       })))
  end

  # GET /sectors
  # GET /sectors.json
  def index
    if params[:without_paging]
      origin_name = session[:org] ? session[:org] : Setting.find_by(slug: 'default_sector_list').value 
      origin = Origin.find_by(name: origin_name)
      if origin.nil?
        origin = Origin.find_by(name:Setting.find_by(slug: 'default_sector_list').value)
      end
      @sectors = Sector.where(origin_id: origin.id)
      !params[:search].blank? && @sectors = @sectors.name_contains(params[:search])
      !params[:display_only].nil? && @sectors = @sectors.where(is_displayable: true)
      @sectors = @sectors.order(:name)
      authorize @sectors, :view_allowed?
      return
    end

    if params[:search]
      @sectors = Sector.where(nil)
                       .name_contains(params[:search])
                       .order(:name)
                       .paginate(page: params[:page], per_page: 20)
    else
      @sectors = Sector.order(:name)
                       .paginate(page: params[:page], per_page: 20)
    end
    authorize @sectors, :view_allowed?
  end

  # GET /sectors/1
  # GET /sectors/1.json
  def show
    authorize @sector, :view_allowed?
  end

  # GET /sectors/new
  def new
    authorize Sector, :mod_allowed?
    @sector = Sector.new
    if (params[:organization_id])
      @organization = Organization.find(params[:organization_id])
      @sector.organizations.push(@organization)
    end
  end

  # GET /sectors/1/edit
  def edit
    authorize @sector, :mod_allowed?
    if (params[:organization_id])
      @organization = Organization.find(params[:organization_id])
    end
  end

  # POST /sectors
  # POST /sectors.json
  def create
    authorize Sector, :mod_allowed?
    @sector = Sector.new(sector_params)

    if params[:selected_organizations].present?
      params[:selected_organizations].keys.each do |organization_id|
        organization = Organization.find(organization_id)
        @sector.organizations.push(organization)
      end
    end

    if params[:selected_use_cases].present?
      params[:selected_use_cases].keys.each do |use_case_id|
        use_case = UseCase.find(use_case_id)
        @sector.use_cases.push(use_case)
      end
    end

    respond_to do |format|
      if @sector.save
        format.html do
          redirect_to @sector,
                      flash: { notice: t('messages.model.created', model: t('model.sector').to_s.humanize) }
        end
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
    authorize @sector, :mod_allowed?
    if params[:selected_organizations].present?
      organizations = Set.new
      params[:selected_organizations].keys.each do |organization_id|
        organization = Organization.find(organization_id)
        organizations.add(organization)
      end
      @sector.organizations = organizations.to_a
    end

    if params[:selected_use_cases].present?
      use_cases = Set.new
      params[:selected_use_cases].keys.each do |use_case_id|
        use_case = UseCase.find(use_case_id)
        use_cases.add(use_case)
      end
      @sector.use_cases = use_cases.to_a
    end

    respond_to do |format|
      if @sector.update(sector_params)
        format.html do
          redirect_to @sector,
                      flash: { notice: t('messages.model.updated', model: t('model.sector').to_s.humanize) }
        end
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
    authorize @sector, :mod_allowed?

    respond_to do |format|
      if @sector.destroy
        format.html { redirect_to sectors_url,
                      flash: { notice: t('messages.model.deleted', model: t('model.sector').to_s.humanize) }}
        format.json { head :no_content }
      else
        format.html { redirect_to sectors_url,
                      flash: { notice: t('messages.model.delete-failed', model: t('model.sector').to_s.humanize) }}
        format.json { head :no_content }
      end
    end
  end

  def duplicates
    @sectors = Array.new
    if params[:current].present?
      current_slug = slug_em(params[:current]);
      original_slug = slug_em(params[:original]);
      if (current_slug != original_slug)
        @sectors = Sector.where(slug: current_slug).to_a
      end
    end
    authorize Sector, :view_allowed?
    render json: @sectors, :only => [:name]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sector
      if !params[:id].scan(/\D/).empty?
        @sector = Sector.find_by(slug: params[:id])
      else
        @sector = Sector.find(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sector_params
      params
        .require(:sector)
        .permit(:name, :confirmation, :slug, :origin_id, :parent_sector_id)
        .tap do |attr|
          if (params[:reslug].present?)
            attr[:slug] = slug_em(attr[:name])
            if (params[:duplicate].present?)
              first_duplicate = Sector.slug_starts_with(attr[:slug]).order(slug: :desc).first
              attr[:slug] = attr[:slug] + generate_offset(first_duplicate).to_s
            end
          end
        end
    end
end
