class UseCasesController < ApplicationController
  before_action :set_use_case, only: [:show, :edit, :update, :destroy]
  before_action :set_sectors, only: [:new, :edit, :update, :show]

  # GET /use_cases
  # GET /use_cases.json
  def index
    if params[:without_paging]
      @use_cases = UseCase
          .name_contains(params[:search])
          .order(:name)
      return
    end

    if params[:search]
      @use_cases = UseCase
          .where(nil)
          .name_contains(params[:search])
          .order(:name)
          .paginate(page: params[:page], per_page: 20)
    else
      @use_cases = UseCase
          .order(:name)
          .paginate(page: params[:page], per_page: 20)
    end
  end

  # GET /use_cases/1
  # GET /use_cases/1.json
  def show
  end

  # GET /use_cases/new
  def new
    @use_case = UseCase.new
  end

  # GET /use_cases/1/edit
  def edit
  end

  def duplicates
    @use_case = Array.new
    if params[:current].present?
      current_slug = slug_em(params[:current]);
      original_slug = slug_em(params[:original]);
      if (current_slug != original_slug)
        @use_case = UseCase.where(slug: current_slug).to_a
      end
    end
    render json: @use_case, :only => [:name]
  end

  # POST /use_cases
  # POST /use_cases.json
  def create
    @use_case = UseCase.new(use_case_params)

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
        format.html { redirect_to @use_case, notice: 'Use case was successfully created.' }
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
    respond_to do |format|
      if @use_case.update(use_case_params)
        format.html { redirect_to @use_case, notice: 'Use case was successfully updated.' }
        format.json { render :show, status: :ok, location: @use_case }
      else
        format.html { render :edit }
        format.json { render json: @use_case.errors, status: :unprocessable_entity }
      end
    end

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
  end

  # DELETE /use_cases/1
  # DELETE /use_cases/1.json
  def destroy
    @use_case.destroy
    respond_to do |format|
      format.html { redirect_to use_cases_url, notice: 'Use case was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_use_case
      @use_case = UseCase.find(params[:id])
      @sector_name = Sector.find(@use_case.sector_id).name
    end

    def set_sectors
      @sectors = Sector.order(:name)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def use_case_params
      params.require(:use_case)
      .permit(:name, :slug, :sector_id)
      .tap do |attr|
        if (params[:reslug].present?)
          attr[:slug] = slug_em(attr[:name])
          if (params[:duplicate].present?)
            first_duplicate = UseCase.slug_starts_with(attr[:slug]).order(slug: :desc).first
            attr[:slug] = attr[:slug] + "_" + calculate_offset(first_duplicate).to_s
          end
        end
      end
    end
end