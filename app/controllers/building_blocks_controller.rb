class BuildingBlocksController < ApplicationController
  before_action :set_building_block, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  # GET /building_blocks
  # GET /building_blocks.json
  def index
    if params[:without_paging]
      @building_blocks = BuildingBlock.name_contains(params[:search])
                                      .order(:name)
      authorize @building_blocks, :view_allowed?
      return
    end

    @building_blocks = filter_building_blocks.order(:name)

    if params[:search]
      @building_blocks = @building_blocks.where('LOWER("building_blocks"."name") like LOWER(?)', "%" + params[:search] + "%")
    end

    @building_blocks = @building_blocks.eager_load(:workflows, :products)
    authorize @building_blocks, :view_allowed?
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
    @bbDesc = BuildingBlockDescription.new
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
    @bbDesc = BuildingBlockDescription.new

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
      begin
        uploader.store!(params[:logo])
      rescue StandardError => e
        @building_block.errors.add(:logo, t('errors.messages.extension_whitelist_error'))
      end
    end

    respond_to do |format|
      if !@building_block.errors.any? && @building_block.save
        if (building_block_params[:bb_desc])
          @bbDesc.building_block_id = @building_block.id
          @bbDesc.locale = I18n.locale
          @bbDesc.description = building_block_params[:bb_desc]
          @bbDesc.save
        end
        format.html { redirect_to @building_block,
                      flash: { notice: t('messages.model.created', model: t('model.building-block').to_s.humanize) }}
        format.json { render :show, status: :created, location: @building_block }
      else
        errMsg = ""
        @organization.errors.each do |attr, err|
          errMsg = err
        end
        format.html { redirect_to new_building_block_url, flash: { error: errMsg } }
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
      begin
        uploader.store!(params[:logo])
      rescue StandardError => e
        @building_block.errors.add(:logo, t('errors.messages.extension_whitelist_error'))
      end
    end

    if (building_block_params[:bb_desc])
      @bbDesc.building_block_id = @building_block.id
      @bbDesc.locale = I18n.locale
      @bbDesc.description = building_block_params[:bb_desc]
      @bbDesc.save
    end

    respond_to do |format|
      if !@building_block.errors.any? && @building_block.update(building_block_params)
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

      sdg_workflows = get_workflows_from_sdgs(sdgs)
      use_case_workflows = get_workflows_from_use_cases(use_cases)

      if (!workflows.empty?)
        filter_workflows = Workflow.all.where('id in (?)', workflows)
        workflow_ids = (filter_workflows.ids & use_case_workflows & sdg_workflows).uniq
      else 
        workflow_ids = (use_case_workflows & sdg_workflows).uniq
      end

      bb_workflows = BuildingBlock.all
      if !use_cases.empty? || ! workflows.empty? || !sdgs.empty?
        bb_workflows = BuildingBlock.all.where('id in (select building_block_id from workflows_building_blocks where workflow_id in (?))', workflow_ids)
      end

      product_ids, product_filter_set = get_products_from_filters(products, origins, with_maturity_assessment, is_launchable)

      bb_products = BuildingBlock.all
      if !products.empty? || !origins.empty? || with_maturity_assessment
        bb_products = BuildingBlock.all.where('building_blocks.id in (select building_block_id from products_building_blocks where product_id in (?))', product_ids)
      end

      filter_bbs = BuildingBlock.all
      if(!bbs.empty?) 
        filter_bbs = BuildingBlock.all.where('id in (?)', bbs).order(:slug)
      end

      if (filter_set)
        ids = (bb_workflows & bb_products & filter_bbs).uniq
        building_blocks = BuildingBlock.where(id: ids)
      else 
        building_blocks = BuildingBlock.all.order(:slug)
      end

      building_blocks
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_building_block
      @building_block = BuildingBlock.find_by(id: params[:id]) or not_found
      @bbDesc = BuildingBlockDescription.where(building_block_id: params[:id], locale: I18n.locale).first
      if !@bbDesc
        @bbDesc = BuildingBlockDescription.new
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def building_block_params
      params
        .require(:building_block)
        .permit(:name, :confirmation, :bb_desc)
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
