class SustainableDevelopmentGoalsController < ApplicationController


  # GET /sustainable_development_goals
  # GET /sustainable_development_goals.json
  def index
    if params[:without_paging]
      @sustainable_development_goals = SustainableDevelopmentGoal
          .name_contains(params[:search])
          .order(:name)
      return
    end

    if params[:search]
      @sustainable_development_goals = SustainableDevelopmentGoal
          .where(nil)
          .name_contains(params[:search])
          .order(:name)
          .paginate(page: params[:page], per_page: 20)
    else
      @sustainable_development_goals = SustainableDevelopmentGoal
          .order(:name)
          .paginate(page: params[:page], per_page: 20)
    end
  end
end
