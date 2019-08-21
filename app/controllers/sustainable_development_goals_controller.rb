class SustainableDevelopmentGoalsController < ApplicationController
  before_action :set_sustainable_development_goal, only: [:show, :edit]

  # GET /sustainable_development_goals
  # GET /sustainable_development_goals.json
  def index
    if params[:without_paging]
      @sustainable_development_goals = SustainableDevelopmentGoal
          .includes(:sdg_targets)
          .name_contains(params[:search])
          .order(:number)
      authorize @sustainable_development_goals, :view_allowed?
      return
    end

    if params[:search]
      @sustainable_development_goals = SustainableDevelopmentGoal
          .includes(:sdg_targets)
          .where(nil)
          .name_contains(params[:search])
          .order(:number)
          .paginate(page: params[:page], per_page: 20)
      authorize @sustainable_development_goals, :view_allowed?
    else
      @sustainable_development_goals = SustainableDevelopmentGoal
          .includes(:sdg_targets)
          .order(:number)
          .paginate(page: params[:page], per_page: 20)
      authorize @sustainable_development_goals, :view_allowed?
    end
  end

  def count
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
