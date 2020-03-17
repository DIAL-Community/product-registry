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

    @sustainable_development_goals = filter_sdgs.order(:number)
    @sustainable_development_goals = @sustainable_development_goals.eager_load(:sdg_targets)

    if params[:search]
      @sustainable_development_goals = @sustainable_development_goals.where('LOWER("sustainable_development_goals"."name") like LOWER(?)', "%" + params[:search] + "%")
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

      filter_set = !(countries.empty? && products.empty? && sectors.empty? && years.empty? &&
                     organizations.empty? && origins.empty? && projects.empty? &&
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

      products, = get_products_from_filters(products, origins, with_maturity_assessment, is_launchable)
      products_ids_parts = [products, sdg_products, org_products, project_product_ids].reject { |x| x.nil? || x.length <= 0 }
                                                                                      .sort { |a, b| a.length <=> b.length }

      product_ids = products_ids_parts[0]
      products_ids_parts.each do |x|
        product_ids &= x
      end

      workflow_product_ids = []
      if !product_ids.nil? && !product_ids.empty?
        workflow_product_ids = get_workflows_from_products(product_ids)
      end

      workflow_bb_ids = get_workflows_from_bbs(bbs)
      workflow_ids_parts = [workflows, workflow_product_ids, workflow_bb_ids].reject { |x| x.nil? || x.length <= 0 }
                                                                             .sort { |a, b| a.length <=> b.length }

      workflow_ids = workflow_ids_parts[0]
      workflow_ids_parts.each do |x|
        workflow_ids &= x
      end

      uc_workflows = []
      if !workflow_ids.nil? && !workflow_ids.empty?
        uc_workflows += UseCase.joins(:workflows)
                               .where('workflows.id in (?)', workflow_ids)
                               .ids
      end

      sdg_uc_ids_parts = [use_cases, uc_workflows].reject { |x| x.nil? || x.length <= 0 }
                                                  .sort { |a, b| a.length <=> b.length }

      sdg_uc_ids = sdg_uc_ids_parts[0]
      sdg_uc_ids_parts.each do |x|
        sdg_uc_ids &= x
      end

      if filter_set
        ids_parts = [sdgs, sdg_uc_ids].reject { |x| x.nil? || x.length <= 0 }
                                      .sort { |a, b| a.length <=> b.length }

        ids = ids_parts[0]
        ids_parts.each do |x|
          ids &= x
        end

        sdgs = SustainableDevelopmentGoal.where(id: ids)
                                         .order(:number)
      else
        sdgs = SustainableDevelopmentGoal.order(:number)
      end
      sdgs
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_sustainable_development_goal
      @sustainable_development_goal = SustainableDevelopmentGoal
      .includes(:sdg_targets)
      .find(params[:id])
    end

end
