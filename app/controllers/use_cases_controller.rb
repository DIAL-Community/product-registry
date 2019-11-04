class UseCasesController < ApplicationController
  before_action :set_use_case, only: [:show, :edit, :update, :destroy]
  before_action :set_sectors, only: [:new, :edit, :update, :show]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  # GET /use_cases
  # GET /use_cases.json
  def index
    if params[:without_paging]
      @use_cases = UseCase.name_contains(params[:search])
      authorize @use_cases, :view_allowed?
      return
    end

    @use_cases = filter_use_cases.order(:name)

    if params[:search]
      @use_cases = @use_cases.where('LOWER("use_cases"."name") like LOWER(?)', "%" + params[:search] + "%")
    end

    @use_cases = @use_cases.eager_load(:workflows, :sdg_targets)
    authorize @use_cases, :view_allowed?
  end

  def count
    @use_cases = filter_use_cases

    authorize @use_cases, :view_allowed?
    render json: @use_cases.count
  end

  # GET /use_cases/1
  # GET /use_cases/1.json
  def show
    authorize @use_case, :view_allowed?
  end

  # GET /use_cases/new
  def new
    authorize UseCase, :mod_allowed?
    @use_case = UseCase.new
    @ucDesc = UseCaseDescription.new
  end

  # GET /use_cases/1/edit
  def edit
    authorize @use_case, :mod_allowed?
  end

  def duplicates
    @use_cases = Array.new
    if params[:current].present?
      current_slug = slug_em(params[:current]);
      original_slug = slug_em(params[:original]);
      if (current_slug != original_slug)
        @use_cases = UseCase.where(slug: current_slug).to_a
      end
    end
    authorize @use_cases, :view_allowed?
    render json: @use_cases, :only => [:name]
  end

  # POST /use_cases
  # POST /use_cases.json
  def create
    authorize UseCase, :mod_allowed?
    @use_case = UseCase.new(use_case_params)
    @ucDesc = UseCaseDescription.new

    if (params[:selected_sdg_targets])
      params[:selected_sdg_targets].keys.each do |sdg_target_id|
        sdg_target = SdgTarget.find(sdg_target_id)
        @use_case.sdg_targets.push(sdg_target)
      end
    end

    if (params[:selected_workflows])
      params[:selected_workflows].keys.each do |workflow_id|
        workflow = Workflow.find(workflow_id)
        @use_case.workflows.push(workflow)
      end
    end

    respond_to do |format|
      if @use_case.save
        if (use_case_params[:bb_desc])
          @ucDesc.use_case_id = @use_case.id
          @ucDesc.locale = I18n.locale
          @ucDesc.description = use_case_params[:uc_desc]
          @ucDesc.save
        end
        format.html { redirect_to @use_case,
                      flash: { notice: t('messages.model.created', model: t('model.use-case').to_s.humanize) }}
        format.json { render :show, status: :created, location: @use_case }
      else
        format.html { render :new }
        format.json { render json: @use_case.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /use_cases/1
  # PATCH/PUT /use_cases/1.json
  def update
    authorize @use_case, :mod_allowed?

    sdg_targets = Set.new
    if (params[:selected_sdg_targets])
      params[:selected_sdg_targets].keys.each do |sdg_target_id|
        sdg_target = SdgTarget.find(sdg_target_id)
        sdg_targets.add(sdg_target)
      end
    end
    @use_case.sdg_targets = sdg_targets.to_a

    workflows = Set.new
    if (params[:selected_workflows])
      params[:selected_workflows].keys.each do |workflow_id|
        workflow = Workflow.find(workflow_id)
        workflows.add(workflow)
      end
    end
    @use_case.workflows = workflows.to_a

    if (use_case_params[:uc_desc])
      @ucDesc.use_case_id = @use_case.id
      @ucDesc.locale = I18n.locale
      @ucDesc.description = use_case_params[:uc_desc]
      @ucDesc.save
    end

    respond_to do |format|
      if @use_case.update(use_case_params)
        format.html { redirect_to @use_case,
                      flash: { notice: t('messages.model.updated', model: t('model.use-case').to_s.humanize) }}
        format.json { render :show, status: :ok, location: @use_case }
      else
        format.html { render :edit }
        format.json { render json: @use_case.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /use_cases/1
  # DELETE /use_cases/1.json
  def destroy
    authorize @use_case, :mod_allowed?
    @use_case.destroy
    respond_to do |format|
      format.html { redirect_to use_cases_url,
                    flash: { notice: t('messages.model.deleted', model: t('model.use-case').to_s.humanize) }}
      format.json { head :no_content }
    end
  end

  private

    def set_use_case
      @use_case = UseCase.find(params[:id])
      @sector_name = Sector.find(@use_case.sector_id).name
      @ucDesc = UseCaseDescription.where(use_case_id: params[:id], locale: I18n.locale).first
      if !@ucDesc
        @ucDesc = UseCaseDescription.new
      end
    end

    def filter_use_cases

      use_cases = sanitize_session_values 'use_cases'
      workflows = sanitize_session_values 'workflows'
      sdgs = sanitize_session_values 'sdgs'
      bbs = sanitize_session_values 'building_blocks'
      products = sanitize_session_values 'products'
      origins = sanitize_session_values 'origins'
      with_maturity_assessment = sanitize_session_value 'with_maturity_assessment'
      is_launchable = sanitize_session_value 'is_launchable'

      filter_set = true;
      if (sdgs.empty? && use_cases.empty? && workflows.empty? && bbs.empty? && products.empty? && origins.empty?)
        filter_set = false;
      end

      sdg_use_cases = UseCase.all
      if (!sdgs.empty?)
        # Get use_cases connected to this sdg
        sdg_targets = SdgTarget.all.where('sdg_number in (?)', sdgs)
        sdg_use_cases = UseCase.all.where('id in (select use_case_id from use_cases_sdg_targets where sdg_target_id in (?))', sdg_targets.ids)
      end
      
      workflow_bbs = get_workflows_from_bbs(bbs)
      
      product_ids, product_filter_set = get_products_from_filters(products, origins, with_maturity_assessment, is_launchable)
      workflow_products = get_workflows_from_products(product_ids, product_filter_set)

      if (!workflows.empty?)
        filter_workflows = Workflow.all.where('id in (?)', workflows)
        workflow_ids = (filter_workflows.ids & workflow_bbs & workflow_products).uniq
      else 
        workflow_ids = (workflow_bbs & workflow_products).uniq
      end

      workflow_use_cases = UseCase.all
      if (product_filter_set == true || !workflows.empty? || !bbs.empty?)
        workflow_use_cases = UseCase.all.where('id in (select use_case_id from workflows_use_cases where workflow_id in (?))', workflow_ids)
      end 

      filter_use_case = UseCase.all
      if(!use_cases.empty?) 
        filter_use_case = UseCase.all.where('id in (?)', use_cases).order(:slug)
      end

      if (filter_set)
        ids = (sdg_use_cases.ids & workflow_use_cases.ids & filter_use_case.ids).uniq
        all_use_cases = UseCase.where(id: ids)
      else 
        all_use_cases = UseCase.all.order(:slug)
      end

      all_use_cases
    end

    def set_sectors
      @sectors = Sector.order(:name)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def use_case_params
      params.require(:use_case)
      .permit(:name, :slug, :sector_id, :uc_desc)
      .tap do |attr|
        if (params[:reslug].present?)
          attr[:slug] = slug_em(attr[:name])
          if (params[:duplicate].present?)
            first_duplicate = UseCase.slug_starts_with(attr[:slug]).order(slug: :desc).first
            attr[:slug] = attr[:slug] + generate_offset(first_duplicate).to_s
          end
        end
      end
    end
end
