class WorkflowsController < ApplicationController
  before_action :set_workflow, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  # GET /workflows
  # GET /workflows.json
  def index
    if params[:without_paging]
      @workflows = Workflow.name_contains(params[:search])
      authorize @workflows, :view_allowed?
      return
    end

    @workflows = filter_workflows.order(:name)

    if params[:search]
      @workflows = @workflows.where('LOWER("workflows"."name") like LOWER(?)', "%" + params[:search] + "%")
    end

    if !params[:without_paging]
      @workflows = @workflows.paginate(page: params[:page], per_page: 20)
    end

    authorize @workflows, :view_allowed?
  end

  def count
    @workflows = filter_workflows

    authorize @workflows, :view_allowed?
    render json: @workflows.count
  end

  # GET /workflows/1
  # GET /workflows/1.json
  def show
    authorize @workflow, :view_allowed?
  end

  # GET /workflows/new
  def new
    authorize Workflow, :mod_allowed?
    @workflow = Workflow.new
    @wfDesc = WorkflowDescription.new
  end

  # GET /workflows/1/edit
  def edit
    authorize @workflow, :mod_allowed?
  end

  # POST /workflows
  # POST /workflows.json
  def create
    authorize Workflow, :mod_allowed?
    @workflow = Workflow.new(workflow_params)
    @wfDesc = WorkflowDescription.new

    if (params[:selected_use_cases])
      params[:selected_use_cases].keys.each do |use_case_id|
        use_case = UseCase.find(use_case_id)
        @workflow.use_cases.push(use_case)
      end
    end

    if (params[:selected_building_blocks])
      params[:selected_building_blocks].keys.each do |building_block_id|
        building_block = BuildingBlock.find(building_block_id)
        @workflow.building_blocks.push(building_block)
      end
    end

    respond_to do |format|
      if @workflow.save
        if (workflow_params[:wf_desc])
          @wfDesc.workflow_id = @workflow.id
          @wfDesc.locale = I18n.locale
          @wfDesc.description = JSON.parse(workflow_params[:wf_desc])
          @wfDesc.save
        end

        format.html { redirect_to @workflow,
                      flash: { notice: t('messages.model.created', model: t('model.workflow').to_s.humanize) }}
        format.json { render :show, status: :created, location: @workflow }
      else
        format.html { render :new }
        format.json { render json: @workflow.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /workflows/1
  # PATCH/PUT /workflows/1.json
  def update
    authorize @workflow, :mod_allowed?

    use_cases = Set.new
    if (params[:selected_use_cases])
      params[:selected_use_cases].keys.each do |use_case_id|
        use_case = UseCase.find(use_case_id)
        use_cases.add(use_case)
      end
    end
    @workflow.use_cases = use_cases.to_a

    building_blocks = Set.new
    if (params[:selected_building_blocks])
      puts "Building blocks: " + params[:selected_building_blocks].to_s
      params[:selected_building_blocks].keys.each do |building_block_id|
        building_block = BuildingBlock.find(building_block_id)
        puts "Found BB: " + building_block.inspect
        building_blocks.add(building_block)
      end
    end
    @workflow.building_blocks = building_blocks.to_a
    puts "WF BBs: " + @workflow.building_blocks.inspect

    if (workflow_params[:wf_desc])
      @wfDesc.workflow_id = @workflow.id
      @wfDesc.locale = I18n.locale
      @wfDesc.description = JSON.parse(workflow_params[:wf_desc])
      @wfDesc.save
    end

    respond_to do |format|
      if @workflow.update(workflow_params)
        format.html { redirect_to @workflow,
                      flash: { notice: t('messages.model.updated', model: t('model.workflow').to_s.humanize) }}
        format.json { render :show, status: :ok, location: @workflow }
      else
        format.html { render :edit }
        format.json { render json: @workflow.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /workflows/1
  # DELETE /workflows/1.json
  def destroy
    authorize @workflow, :mod_allowed?
    @workflow.destroy
    respond_to do |format|
      format.html { redirect_to workflows_url,
                    flash: { notice: t('messages.model.deleted', model: t('model.workflow').to_s.humanize) }}
      format.json { head :no_content }
    end
  end

  def duplicates
    @workflows = Array.new
    if params[:current].present?
      current_slug = slug_em(params[:current]);
      original_slug = slug_em(params[:original]);
      if (current_slug != original_slug)
        @workflows = Workflow.where(slug: current_slug).to_a
      end
    end
    authorize @workflows, :view_allowed?
    render json: @workflows, :only => [:name]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_workflow
      @workflow = Workflow.find_by(id: params[:id]) or not_found
      @wfDesc = WorkflowDescription.where(workflow_id: params[:id], locale: I18n.locale).first
      if !@wfDesc
        @wfDesc = WorkflowDescription.new
      end
    end

    def filter_workflows
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

      with_maturity_assessment = sanitize_session_value 'with_maturity_assessment'
      is_launchable = sanitize_session_value 'is_launchable'

      countries = sanitize_session_values 'countries'
      sectors = sanitize_session_values 'sectors'

      filter_set = !(countries.empty? && products.empty? && sectors.empty? && years.empty? &&
                     organizations.empty? && origins.empty? && projects.empty? &&
                     sdgs.empty? && use_cases.empty? && workflows.empty? && bbs.empty?) ||
                   endorser_only || aggregator_only || with_maturity_assessment || is_launchable

      sdg_use_cases = get_use_cases_from_sdgs(sdgs)
      use_case_ids = filter_and_intersect_arrays([sdg_use_cases, use_cases])
      use_case_workflow_ids = get_workflows_from_use_cases(use_case_ids)

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

      product_bbs = []
      product_ids = filter_and_intersect_arrays([products, sdg_products, org_products, project_product_ids])
      if !product_ids.nil? && !product_ids.empty?
        product_bbs = get_bbs_from_products(product_ids)
      end

      bb_workflow_ids = []
      bb_ids = filter_and_intersect_arrays([bbs, product_bbs])
      if !bb_ids.nil? && !bb_ids.empty?
        bb_workflow_ids = Workflow.joins(:building_blocks)
                                  .where('building_blocks.id in (?)', bb_ids)
                                  .ids
      end

      if filter_set
        ids = filter_and_intersect_arrays([workflows, use_case_workflow_ids, bb_workflow_ids])
        Workflow.where(id: ids).order(:slug)
      else
        Workflow.order(:slug)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def workflow_params
      params.require(:workflow)
      .permit(:name, :slug, :wf_desc, :other_names, :category)
      .tap do |attr|
        if (params[:reslug].present?)
          attr[:slug] = slug_em(attr[:name])
          if (params[:duplicate].present?)
            first_duplicate = Workflow.slug_starts_with(attr[:slug]).order(slug: :desc).first
            attr[:slug] = attr[:slug] + generate_offset(first_duplicate).to_s
          end
        end
      end
    end
end
