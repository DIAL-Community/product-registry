class CountriesController < ApplicationController
  before_action :set_country, only: [:show, :edit, :update, :destroy]

  def unique_search
    record = Country.eager_load(:organizations)
                    .find_by(slug: params[:id])
    if record.nil?
      return render(json: {}, status: :not_found)
    end

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
    if params[:page].present? && params[:page].to_i > 0
      current_page = params[:page].to_i
    end

    if params[:search].present?
      countries = countries.name_contains(params[:search])
    end

    results = {
      url: request.original_url,
      count: countries.count,
      page_size: default_page_size
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if countries.count > default_page_size * current_page
      query["page"] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = URI.decode(uri.to_s)
    end

    if current_page > 1
      query["page"] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = URI.decode(uri.to_s)
    end

    results['results'] = countries.paginate(page: current_page, per_page: default_page_size)
                                  .eager_load(:organizations)

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
  def show
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_country
    @country = Country.find_by(slug: params[:id])
  end
end
