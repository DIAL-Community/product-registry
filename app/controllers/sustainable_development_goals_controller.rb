class SustainableDevelopmentGoalsController < ApplicationController
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

    def filter_sdgs
      use_cases = sanitize_session_values 'use_cases'
      workflows = sanitize_session_values 'workflows'
      sdgs = sanitize_session_values 'sdgs'
      bbs = sanitize_session_values 'building_blocks'
      products = sanitize_session_values 'products'
      origins = sanitize_session_values 'origins'
      organizations = sanitize_session_values 'organizations'
      projects = sanitize_session_values 'projects'

      endorser_only = sanitize_session_value 'endorser_only'
      aggregator_only = sanitize_session_value 'aggregator_only'
      years = sanitize_session_values 'years'

      countries = sanitize_session_values 'countries'
      sectors = sanitize_session_values 'sectors'

      with_maturity_assessment = sanitize_session_value 'with_maturity_assessment'
      is_launchable = sanitize_session_value 'is_launchable'
      product_type = sanitize_session_values 'product_type'

      tags = sanitize_session_values 'tags'

      filter_set = !(countries.empty? && products.empty? && sectors.empty? && years.empty? &&
                     organizations.empty? && origins.empty? && projects.empty? && tags.empty? && product_type.empty? &&
                     sdgs.empty? && use_cases.empty? && workflows.empty? && bbs.empty?) ||
                   endorser_only || aggregator_only || with_maturity_assessment || is_launchable

      project_product_ids = []
      !projects.empty? && project_product_ids = Product.joins(:projects)
                                                       .where('projects.id in (?)', projects)
                                                       .ids

      # Filter out organizations based on filter input.
      org_ids = get_organizations_from_filters(organizations, years, sectors, countries, endorser_only, aggregator_only)
      org_filtered = (!years.empty? || !organizations.empty? || endorser_only || aggregator_only ||
                      !sectors.empty? || !countries.empty?)

      # Filter out project based on organization filter above.
      org_projects = []
      org_filtered && org_projects += Project.joins(:organizations)
                                             .where('organizations.id in (?)', org_ids)
                                             .ids

      # Add products based on the project filtered above.
      !org_projects.empty? && project_product_ids += Product.joins(:projects)
                                                            .where('projects.id in (?)', org_projects)
                                                            .ids

      sdg_products = []
      # if !sdgs.empty?
      #   sdg_products += Product.joins(:sustainable_development_goals)
      #                          .where('sustainable_development_goal_id in (?)', sdgs)
      #                          .ids
      # end

      org_products = []
      if !organizations.empty?
        org_products += Product.joins(:organizations)
                               .where('organization_id in (?)', organizations)
                               .ids
      end

      products = get_products_from_filters(products, origins, with_maturity_assessment, is_launchable, product_type, tags)

      workflow_product_ids = []
      product_ids = filter_and_intersect_arrays([products, sdg_products, org_products, project_product_ids])
      if !product_ids.nil? && !product_ids.empty?
        workflow_product_ids = get_workflows_from_products(product_ids)
      end

      workflow_bb_ids = get_workflows_from_bbs(bbs)

      uc_workflows = []
      workflow_ids = filter_and_intersect_arrays([workflows, workflow_product_ids, workflow_bb_ids])
      if !workflow_ids.nil? && !workflow_ids.empty?
        uc_workflows += UseCaseStep.joins(:workflows)
                                   .where('workflows.id in (?)', workflow_ids)
                                   .select('use_case_id')
                                   .pluck('use_case_id')
      end

      sdg_uc_ids = filter_and_intersect_arrays([use_cases, uc_workflows])

      sdg_numbers = []
      if !sdg_uc_ids.nil? && !sdg_uc_ids.empty?
        sdg_numbers = UseCase.joins(:sdg_targets)
                             .where('use_cases.id in (?)', sdg_uc_ids)
                             .select('sdg_number')
                             .pluck('sdg_number')
      end

      if filter_set
        goals = SustainableDevelopmentGoal
        if !sdgs.nil? && !sdgs.empty?
          goals = goals.where(id: sdgs)
          if !sdg_numbers.empty?
            goals = goals.or(SustainableDevelopmentGoal.where(number: sdg_numbers))
          end
        elsif !sdg_numbers.empty?
          goals = goals.where(number: sdg_numbers)
        else
          # Nothing is matching the criteria. Return nothing.
          goals = SustainableDevelopmentGoal.none
        end
        goals
      else
        SustainableDevelopmentGoal.order(:number)
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_sustainable_development_goal
      @sustainable_development_goal = SustainableDevelopmentGoal
      .includes(:sdg_targets)
      .find(params[:id])
    end

end
