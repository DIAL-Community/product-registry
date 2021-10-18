class SustainableDevelopmentGoalsController < ApplicationController
  include FilterConcern
  include ApiFilterConcern

  before_action :set_sustainable_development_goal, only: [:show, :edit]

  def unique_search
    record = SustainableDevelopmentGoal.eager_load(:sdg_targets, sdg_targets: :use_cases)
                                       .find_by(slug: params[:id])
    if record.nil?
      return render(json: {}, status: :not_found)
    end

    render(json: record.to_json(SustainableDevelopmentGoal.serialization_options
                                                          .merge({
                                                            item_path: request.original_url,
                                                            include_relationships: true
                                                          })))
  end

  def simple_search
    default_page_size = 20
    sdgs = SustainableDevelopmentGoal.eager_load(:sdg_targets, sdg_targets: :use_cases)

    current_page = 1
    if params[:page].present? && params[:page].to_i > 0
      current_page = params[:page].to_i
    end

    if valid_array_parameter(params[:sdgs])
      sdgs = sdgs.where('sustainable_development_goals.slug in (?)', params[:sdgs])
    end

    if params[:search].present?
      sdg_name = sdgs.name_contains(params[:search])
      sdg_desc = sdgs.where("LOWER(long_title) like LOWER(?)", "%#{params[:search]}%")
      sdg_target = sdgs.joins(:sdg_targets).where("LOWER(sdg_targets.name) like LOWER(?)", "%#{params[:search]}%")
      sdgs = sdgs.where(id: (sdg_name + sdg_desc + sdg_target).uniq)
    end

    results = {
      url: request.original_url,
      count: sdgs.count,
      page_size: default_page_size
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if sdgs.count > default_page_size * current_page
      query["page"] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = URI.decode(uri.to_s)
    end

    if current_page > 1
      query["page"] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = URI.decode(uri.to_s)
    end

    results['results'] = sdgs.paginate(page: current_page, per_page: default_page_size)
                             .order(:number)

    ## Should we do granular and control it using params like this?
    # relationship_options = {}
    # if params[:include_products].present? && params[:include_products].to_s.downcase == 'true'
    #   relationship_options[:include_products] = true
    # end
    # if params[:include_use_cases].present? && params[:include_use_cases].to_s.downcase == 'true'
    #   relationship_options[:include_use_cases] = true
    # end
    # render(json: results.to_json(SustainableDevelopmentGoal.serialization_options
    #                                                        .merge(relationship_options)
    #                                                        .merge({
    #                                                          collection_path: uri.to_s
    #                                                        })))
    uri.fragment = uri.query = nil

    respond_to do |format|
      format.csv do
        render(csv: results.to_csv, filename: 'csv-sdgs')
      end
      format.json do
        render(json: results.to_json(SustainableDevelopmentGoal.serialization_options
                                                               .merge({
                                                                 include_relationships: true,
                                                                 collection_path: uri.to_s
                                                               })))
      end
    end
  end

  # GET /sustainable_development_goals
  # GET /sustainable_development_goals.json
  def index
    if params[:without_paging]
      @sustainable_development_goals = SustainableDevelopmentGoal.all
      unless params[:search].blank?
        @sustainable_development_goals = @sustainable_development_goals.name_contains(params[:search])
      end
      @sustainable_development_goals = @sustainable_development_goals.order(:name)
      return
    end

    @sustainable_development_goals = filter_sdgs.eager_load(:sdg_targets).order(:number)
    @sustainable_development_goals = @sustainable_development_goals.eager_load(:sdg_targets)

    if params[:search]
      @sustainable_development_goals = @sustainable_development_goals.where(
        'LOWER("sustainable_development_goals"."name") like LOWER(?)', "%#{params[:search]}%"
      )
    end
    authorize @sustainable_development_goals, :view_allowed?
  end

  def count
    @sustainable_development_goals = filter_sdgs

    authorize @sustainable_development_goals, :view_allowed?
    render json: @sustainable_development_goals.count
  end

  def show
    authorize @sustainable_development_goal, :view_allowed?
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_sustainable_development_goal
      @sustainable_development_goal = SustainableDevelopmentGoal
      .includes(:sdg_targets)
      .find(params[:id])
    end

end
