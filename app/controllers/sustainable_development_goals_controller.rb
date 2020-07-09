class SustainableDevelopmentGoalsController < ApplicationController
  include FilterConcern
  
  before_action :set_sustainable_development_goal, only: [:show, :edit]

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
