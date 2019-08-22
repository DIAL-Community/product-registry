class BuildingBlocksController < ApplicationController
  before_action :set_building_block, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  # GET /building_blocks
  # GET /building_blocks.json
  def index
    if params[:without_paging]
      @building_blocks = BuildingBlock
        .name_contains(params[:search])
        .order(:name)
      authorize @building_blocks, :view_allowed?
      return
    end

    if params[:search]
      @building_blocks = BuildingBlock
        .where(nil)
        .name_contains(params[:search])
        .order(:name)
        .paginate(page: params[:page], per_page: 20)
      authorize @building_blocks, :view_allowed?
    else
      @building_blocks = filter_building_blocks
        .order(:name)
        .paginate(page: params[:page], per_page: 20)
      authorize @building_blocks, :view_allowed?
    end
  end

  def count
    @building_blocks = filter_building_blocks

    authorize @building_blocks, :view_allowed?
    render json: @building_blocks.count
  end

  # GET /building_blocks/1
  # GET /building_blocks/1.json
  def show
    authorize @building_block, :view_allowed?
  end

  # GET /building_blocks/new
  def new
    authorize BuildingBlock, :mod_allowed?
    @building_block = BuildingBlock.new
  end

  # GET /building_blocks/1/edit
  def edit
    authorize @building_block, :mod_allowed?
  end

  # POST /building_blocks
  # POST /building_blocks.json
  def create
    authorize BuildingBlock, :mod_allowed?
    @building_block = BuildingBlock.new(building_block_params)

    if (params[:selected_products])
      params[:selected_products].keys.each do |product_id|
        product = Product.find(product_id)
        @building_block.products.push(product)
      end
    end

    if (params[:selected_workflows])
      params[:selected_workflows].keys.each do |workflow_id|
        workflow = Workflow.find(workflow_id)
        @building_block.workflows.push(workflow)
      end
    end

    if params[:logo].present?
      uploader = LogoUploader.new(@building_block, params[:logo].original_filename, current_user)
      uploader.store!(params[:logo])
    end

    respond_to do |format|
      if @building_block.save
        format.html { redirect_to @building_block,
                      flash: { notice: t('messages.model.created', model: t('model.building-block').to_s.humanize) }}
        format.json { render :show, status: :created, location: @building_block }
      else
        format.html { render :new }
        format.json { render json: @building_block.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /building_blocks/1
  # PATCH/PUT /building_blocks/1.json
  def update
    authorize @building_block, :mod_allowed?

    products = Set.new
    if (params[:selected_products])
      params[:selected_products].keys.each do |product_id|
        product = Product.find(product_id)
        products.add(product)
      end
    end
    @building_block.products = products.to_a

    workflows = Set.new
    if (params[:selected_workflows])
      params[:selected_workflows].keys.each do |workflow_id|
        workflow = Workflow.find(workflow_id)
        workflows.add(workflow)
      end
    end
    @building_block.workflows = workflows.to_a

    if params[:logo].present?
      uploader = LogoUploader.new(@building_block, params[:logo].original_filename, current_user)
      uploader.store!(params[:logo])
    end

    respond_to do |format|
      if @building_block.update(building_block_params)
        format.html { redirect_to @building_block,
                      flash: { notice: t('messages.model.updated', model: t('model.building-block').to_s.humanize) }}
        format.json { render :show, status: :ok, location: @building_block }
      else
        format.html { render :edit }
        format.json { render json: @building_block.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /building_blocks/1
  # DELETE /building_blocks/1.json
  def destroy
    authorize @building_block, :mod_allowed?
    @building_block.destroy
    respond_to do |format|
      format.html { redirect_to building_blocks_url,
                    flash: { notice: t('messages.model.deleted', model: t('model.building-block').to_s.humanize) }}
      format.json { head :no_content }
    end
  end

  def duplicates
    @building_blocks = Array.new
    if params[:current].present?
      current_slug = slug_em(params[:current]);
      original_slug = slug_em(params[:original]);
      if (current_slug != original_slug)
        @building_blocks = BuildingBlock.where(slug: current_slug).to_a
      end
    end
    authorize @building_blocks, :view_allowed?
    render json: @building_blocks, :only => [:name]
  end

  private

    def filter_building_blocks
      building_blocks = BuildingBlock.all.order(:slug)

      use_cases = sanitize_session_values 'use_cases'
      workflows = sanitize_session_values 'workflows'
      sdgs = sanitize_session_values 'years'

      #!use_cases.empty? && building_blocks = building_blocks.joins(:use_cases).where('use_case.id in (?)', use_cases)
      !workflows.empty? && building_blocks = building_blocks.joins(:workflows).where('workflow_id in (?)', workflows)
      #!sdgs.empty? && building_blocks = building_blocks.joins(:sustainable_development_goals).where('sustainable_development_goal.id in (?)', sdgs)

      puts "Count: " + building_blocks.count.to_s

      building_blocks
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_building_block
      @building_block = BuildingBlock.find(params[:id])
      @bbJson = JSON.parse(@building_block.description, object_class: OpenStruct)
      if @bbJson.digital_function
        @digital_functions = @bbJson.digital_function.split("•").drop(1)
      else
        @digital_functions = []
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def building_block_params
      params
        .require(:building_block)
        .permit(:name, :confirmation)
        .tap do |attr|
          if (params[:reslug].present?)
            attr[:slug] = slug_em(attr[:name])
            if (params[:duplicate].present?)
              first_duplicate = BuildingBlock.slug_starts_with(attr[:slug]).order(slug: :desc).first
              attr[:slug] = attr[:slug] + generate_offset(first_duplicate).to_s
            end
          end
        end
    end
end
