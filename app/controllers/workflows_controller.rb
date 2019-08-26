class WorkflowsController < ApplicationController
  before_action :set_workflow, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  # GET /workflows
  # GET /workflows.json
  def index

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
    if (params[:selected_bulding_blocks])
      params[:selected_bulding_blocks].keys.each do |building_block_id|
        building_block = BuildingBlock.find(building_block_id)
        building_blocks.add(building_block)
      end
    end
    @workflow.building_blocks = building_blocks.to_a

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
      @workflow = Workflow.find(params[:id])
      @workflowJson = JSON.parse(@workflow.description, object_class: OpenStruct)
    end

    def filter_workflows

      use_cases = sanitize_session_values 'use_cases'
      workflows = sanitize_session_values 'workflows'
      sdgs = sanitize_session_values 'sdgs'
      bbs = sanitize_session_values 'building_blocks'
      products = sanitize_session_values 'products'

      filter_set = true;
      if (sdgs.empty? && use_cases.empty? && workflows.empty? && bbs.empty? && products.empty?)
        filter_set = false;
      end

      if (!sdgs.empty?)
        # Get use_cases connected to this sdg
        sdg_targets = SdgTarget.all.where('sdg_number in (?)', sdgs)
        sdg_use_cases = UseCase.all.where('id in (select use_case_id from use_cases_sdg_targets where sdg_target_id in (?))', sdg_targets.ids)
      end
      if (sdg_use_cases)
        combined_use_cases = (use_cases + sdg_use_cases).uniq
      else
        combined_use_cases = use_cases
      end

      use_case_workflows = Workflow.none
      if (!combined_use_cases.empty? || sdg_use_cases)
        # Get workflows connected to this use case
        use_case_workflows = Workflow.all.joins(:use_cases).where('use_case_id in (?)', combined_use_cases).distinct
      end 

      if (!products.empty?)
        # Find building blocks for selected products and from there join to workflows
        product_bbs = BuildingBlock.all.joins(:products).where('product_id in (?)', products)
      end
      if (product_bbs)
        combined_bbs = (product_bbs + bbs).uniq
      else
        combined_bbs = bbs
      end

      bb_workflows = Workflow.none
      if (!bbs.empty? || product_bbs) 
        bb_workflows = Workflow.all.joins(:building_blocks).where('building_block_id in (?)', combined_bbs).distinct
      end

      filter_workflow = Workflow.none
      if(!workflows.empty?) 
        filter_workflow = Workflow.all.where('id in (?)', workflows).order(:slug)
      end

      if (filter_set)
        ids = (use_case_workflows + bb_workflows + filter_workflow).uniq
        all_workflows = Workflow.where(id: ids)
      else 
        all_workflows = Workflow.all.order(:slug)
      end

      all_workflows
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def workflow_params
      params.require(:workflow)
      .permit(:name, :slug, :description, :other_names, :category)
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
