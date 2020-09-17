class WorkflowsController < ApplicationController
  include FilterConcern
  
  before_action :set_workflow, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_current_user, only: [:edit, :update, :destroy]

  # GET /workflows
  # GET /workflows.json
  def index
    if params[:without_paging]
      @workflows = Workflow.name_contains(params[:search])
      authorize @workflows, :view_allowed?
      return
    end

    @workflows = filter_workflows.eager_load(:building_blocks, :use_case_steps).order(:name)

    if params[:search]
      @workflows = @workflows.where('LOWER("workflows"."name") like LOWER(?)', "%#{params[:search]}%")
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

  def export_data
    @workflows = Workflow.where(id: filter_workflows).eager_load(:building_blocks, :use_case_steps)
    authorize(@workflows, :view_allowed?)
    respond_to do |format|
      format.csv do
        render csv: @workflows, filename: 'exported-workflow'
      end
      format.json do
        render json: @workflows.to_json(Workflow.serialization_options)
      end
    end
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
    @wf_desc = WorkflowDescription.new
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
    @workflow.set_current_user(current_user)
    @wf_desc = WorkflowDescription.new
    @wf_desc.set_current_user(current_user)

    if params[:selected_building_blocks].present?
      params[:selected_building_blocks].keys.each do |building_block_id|
        building_block = BuildingBlock.find(building_block_id)
        @workflow.building_blocks.push(building_block)
      end
    end

    respond_to do |format|
      if @workflow.save
        if workflow_params[:wf_desc].present?
          @wf_desc.workflow_id = @workflow.id
          @wf_desc.locale = I18n.locale
          @wf_desc.description = workflow_params[:wf_desc]
          @wf_desc.save
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

    building_blocks = Set.new
    if (params[:selected_building_blocks])
      params[:selected_building_blocks].keys.each do |building_block_id|
        building_block = BuildingBlock.find(building_block_id)
        building_blocks.add(building_block)
      end
    end
    @workflow.building_blocks = building_blocks.to_a

    if workflow_params[:wf_desc].present?
      @wf_desc.workflow_id = @workflow.id
      @wf_desc.locale = I18n.locale
      @wf_desc.description = workflow_params[:wf_desc]
      @wf_desc.save
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
    authorize Workflow, :view_allowed?
    render json: @workflows, :only => [:name]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_workflow
      if !params[:id].scan(/\D/).empty?
        @workflow = Workflow.find_by(slug: params[:id]) or not_found
      else
        @workflow = Workflow.find_by(id: params[:id]) or not_found
      end
      @wf_desc = WorkflowDescription.where(workflow_id: @workflow, locale: I18n.locale).first
      if !@wf_desc
        @wf_desc = WorkflowDescription.new
      end
    end

    def set_current_user
      @workflow.set_current_user(current_user)
      @wf_desc.set_current_user(current_user)
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
