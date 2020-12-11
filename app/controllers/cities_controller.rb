class CitiesController < ApplicationController
  before_action :set_city, only: [:show, :edit, :update, :destroy]

  def unique_search
    record = City.eager_load(:region)
                 .find_by(slug: params[:id])
    if record.nil?
      return render(json: {}, status: :not_found)
    end

    render(json: record.to_json(City.serialization_options
                                    .merge({
                                      item_path: request.original_url,
                                      include_relationships: true
                                    })))
  end

  def simple_search
    default_page_size = 20
    cities = City

    current_page = 1
    if params[:page].present? && params[:page].to_i > 0
      current_page = params[:page].to_i
    end

    if params[:search].present?
      cities = cities.name_contains(params[:search])
    end

    results = {
      url: request.original_url,
      count: cities.count,
      page_size: default_page_size
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if cities.count > default_page_size * current_page
      query["page"] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = URI.decode(uri.to_s)
    end

    if current_page > 1
      query["page"] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = URI.decode(uri.to_s)
    end

    results['results'] = cities.paginate(page: current_page, per_page: default_page_size)
                               .eager_load(:region)
                               .order(:slug)

    uri.fragment = uri.query = nil
    render(json: results.to_json(City.serialization_options
                                     .merge({
                                       collection_path: uri.to_s,
                                       include_relationships: true
                                     })))
  end

  # GET /cities
  # GET /cities.json
  def index
    if params[:without_paging]
      @cities = City.order(:name)
      !params[:search].blank? && @cities = @cities.name_contains(params[:search])
      authorize(@cities, :view_allowed?)
      return
    end

    if params[:search]
      @cities = City.where(nil)
                    .name_contains(params[:search])
                    .order(:name)
                    .paginate(page: params[:page], per_page: 20)
    else
      @cities = City.order(:name)
                    .paginate(page: params[:page], per_page: 20)
    end
    authorize(@cities, :view_allowed?)
  end

  # GET /cities/1
  # GET /cities/1.json
  def show
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_city
    @city = City.find_by(slug: params[:id])
  end
end
