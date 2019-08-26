class SustainableDevelopmentGoalsController < ApplicationController
  before_action :set_sustainable_development_goal, only: [:show, :edit]

  # GET /sustainable_development_goals
  # GET /sustainable_development_goals.json
  def index
    
    @sustainable_development_goals = filter_sdgs.order(:name)

    if params[:search]
      @sustainable_development_goals = @sustainable_development_goals.where('LOWER("sustainable_development_goals"."name") like LOWER(?)', "%" + params[:search] + "%")
    end

    if !params[:without_paging]
      @sustainable_development_goals = @sustainable_development_goals.paginate(page: params[:page], per_page: 20)
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

    def filter_sdgs

      use_cases = sanitize_session_values 'use_cases'
      workflows = sanitize_session_values 'workflows'
      sdgs = sanitize_session_values 'sdgs'
      bbs = sanitize_session_values 'building_blocks'
      products = sanitize_session_values 'products'

      filter_set = true;
      if (sdgs.empty? && use_cases.empty? && workflows.empty? && bbs.empty? && products.empty?)
        filter_set = false;
      end

      if (!bbs.empty?)
        bb_workflows = Workflow.all.joins(:building_blocks).where('building_block_id in (?)', bbs).distinct
      end
      if (bb_workflows)
        combined_workflows = (bb_workflows + workflows).uniq
      else
        combined_workflows = workflows
      end

      if (!workflows.empty? || combined_workflows)
        workflow_use_cases = UseCase.all.joins(:workflows).where('workflow_id in (?)', combined_workflows).distinct
      end
      if (workflow_use_cases)
        combined_use_cases = (workflow_use_cases + use_cases).uniq
      else
        combined_use_cases = use_cases
      end

      use_case_sdgs = SustainableDevelopmentGoal.none
      if (!use_cases.empty? || combined_use_cases)
        # Get sdgs connected to this use_case
        sdg_targets = SdgTarget.all.joins(:use_cases).where('use_case_id in (?)', combined_use_cases)
        use_case_sdgs = SustainableDevelopmentGoal.all.where('id in (select distinct(sdg_number) from sdg_targets where id in (?))', sdg_targets.ids)
      end

      product_sdgs = SustainableDevelopmentGoal.none
      if (!products.empty?)
        product_sdgs = SustainableDevelopmentGoal.all.joins(:products).where('product_id in (?)', products)
      end

      filter_sdgs = SustainableDevelopmentGoal.none
      if(!sdgs.empty?) 
        filter_sdgs = SustainableDevelopmentGoal.all.where('id in (?)', sdgs).order(:slug)
      end

      if (filter_set)
        ids = (use_case_sdgs + product_sdgs + filter_sdgs).uniq
        all_sdgs = SustainableDevelopmentGoal.where(id: ids)
      else 
        all_sdgs = SustainableDevelopmentGoal.all.order(:slug)
      end

      all_sdgs
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_sustainable_development_goal
      @sustainable_development_goal = SustainableDevelopmentGoal
      .includes(:sdg_targets)
      .find(params[:id])
    end

end
