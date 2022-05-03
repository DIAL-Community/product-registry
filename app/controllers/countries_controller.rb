# frozen_string_literal: true

class CountriesController < ApplicationController
  acts_as_token_authentication_handler_for User, only: %i[index new create edit update destroy]

  before_action :set_country, only: %i[show edit update destroy]

  def unique_search
    record = Country.find_by(slug: params[:id])
    return render(json: {}, status: :not_found) if record.nil?

    render(json: record.as_json(Country.serialization_options
                                       .merge({
                                         item_path: request.original_url,
                                         include_relationships: true
                                       })))
  end

  def simple_search
    default_page_size = 20
    countries = Country.order(:slug)

    current_page = 1
    current_page = params[:page].to_i if params[:page].present? && params[:page].to_i.positive?

    countries = countries.name_contains(params[:search]) if params[:search].present?

    results = {
      url: request.original_url,
      count: countries.count,
      page_size: default_page_size
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if countries.count > default_page_size * current_page
      query['page'] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = URI.decode(uri.to_s)
    end

    if current_page > 1
      query['page'] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = URI.decode(uri.to_s)
    end

    results['results'] = countries.paginate(page: current_page, per_page: default_page_size)

    uri.fragment = uri.query = nil
    render(json: results.to_json(Country.serialization_options
                                        .merge({
                                          collection_path: uri.to_s,
                                          include_relationships: true
                                        })))
  end

  # GET /countries
  # GET /countries.json
  def index
    if params[:without_paging]
      @countries = Country.order(:name)
      !params[:search].blank? && @countries = @countries.name_contains(params[:search])
      authorize(@countries, :view_allowed?)
      return
    end

    if params[:search]
      @countries = Country.where(nil)
                          .name_contains(params[:search])
                          .order(:name)
                          .paginate(page: params[:page], per_page: 20)
    else
      @countries = Country.order(:name)
                          .paginate(page: params[:page], per_page: 20)
    end
    authorize(@countries, :view_allowed?)
  end

  # GET /countries/1
  # GET /countries/1.json
  def show; end

  def new
    authorize(Country, :mod_allowed?)
    @country = Country.new
  end

  # GET /country/1/edit
  def edit
    authorize(@country, :mod_allowed?)
    @country = Country.find(params[:country_id]) if params[:country_id]
  end

  # POST /sectors
  # POST /sectors.json
  def create
    authorize(Sector, :mod_allowed?)
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
          redirect_to(@sector,
                      flash: { notice: t('messages.model.created', model: t('model.sector').to_s.humanize) })
        end
        format.json { render(:show, status: :created, location: @sector) }
      else
        format.html { render(:new) }
        format.json { render(json: @sector.errors, status: :unprocessable_entity) }
      end
    end
  end

  # PATCH/PUT /sectors/1
  # PATCH/PUT /sectors/1.json
  def update
    authorize(@sector, :mod_allowed?)
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
          redirect_to(@sector,
                      flash: { notice: t('messages.model.updated', model: t('model.sector').to_s.humanize) })
        end
        format.json { render(:show, status: :ok, location: @sector) }
      else
        format.html { render(:edit) }
        format.json { render(json: @sector.errors, status: :unprocessable_entity) }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_country
    @country = Country.find_by(slug: params[:id])
  end
end
