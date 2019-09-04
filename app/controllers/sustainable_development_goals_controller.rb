class SustainableDevelopmentGoalsController < ApplicationController
  before_action :set_sustainable_development_goal, only: [:show, :edit]

  # GET /sustainable_development_goals
  # GET /sustainable_development_goals.json
  def index

    @sustainable_development_goals = filter_sdgs.order(:number)

    if params[:search]
      @sustainable_development_goals = @sustainable_development_goals.where('LOWER("sustainable_development_goals"."name") like LOWER(?)', "%" + params[:search] + "%")
    end

    @sustainable_development_goals = @sustainable_development_goals.eager_load(:sdg_targets)
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
      origins = sanitize_session_values 'origins'
      with_maturity_assessment = sanitize_session_value 'with_maturity_assessment'

      filter_set = true;
      if (sdgs.empty? && use_cases.empty? && workflows.empty? && bbs.empty? && products.empty? && origins.empty?)
        filter_set = false;
      end

      use_case_sdgs = SustainableDevelopmentGoal.all

      workflow_use_cases = get_use_cases_from_workflows(workflows)
      bb_use_cases = get_use_cases_from_bbs(bbs)

      if (!use_cases.empty?)
        filter_use_cases = UseCase.all.where('id in (?)', use_cases)
        use_case_ids = (filter_use_cases.ids & workflow_use_cases & bb_use_cases).uniq
      else
        use_case_ids = (workflow_use_cases & bb_use_cases).uniq
      end

      if !use_cases.empty? || ! workflows.empty? || !bbs.empty?
        sdg_targets = SdgTarget.all.joins(:use_cases).where('use_case_id in (?)', use_case_ids)
        use_case_sdgs = SustainableDevelopmentGoal.all.where('id in (select distinct(sdg_number) from sdg_targets where id in (?))', sdg_targets.ids)
      end

      product_ids, product_filter_set = get_products_from_filters(products, origins, with_maturity_assessment)

      product_sdgs = SustainableDevelopmentGoal.all
      if product_filter_set == true
        product_sdgs = SustainableDevelopmentGoal.all.where('sustainable_development_goals.id in (select sustainable_development_goal_id from products_sustainable_development_goals where product_id in (?))', product_ids)
      end

      filter_sdgs = SustainableDevelopmentGoal.all
      if(!sdgs.empty?)
        filter_sdgs = SustainableDevelopmentGoal.all.where('id in (?)', sdgs).order(:number)
      end

      if (filter_set)
        ids = (use_case_sdgs.ids & product_sdgs.ids & filter_sdgs.ids).uniq
        all_sdgs = SustainableDevelopmentGoal.where(id: ids)
      else
        all_sdgs = SustainableDevelopmentGoal.all.order(:number)
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
