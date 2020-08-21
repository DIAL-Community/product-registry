class BuildingBlocksController < ApplicationController
  include FilterConcern

  before_action :set_building_block, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :duplicate]

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

    if params[:mature].present? && params[:mature].to_s.downcase == 'true'
      @building_blocks = @building_blocks.where(':tag = building_blocks.maturity', tag: 'Mature')
    end

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
    authorize(BuildingBlock, :create_allowed?)
    @building_block = BuildingBlock.new
    @bb_desc = BuildingBlockDescription.new
  end

  # GET /building_blocks/1/edit
  def edit
    authorize @building_block, :mod_allowed?
  end

  # POST /building_blocks
  # POST /building_blocks.json
  def create
    authorize(BuildingBlock, :create_allowed?)
    @building_block = BuildingBlock.new(building_block_params)
    @bb_desc = BuildingBlockDescription.new

    if params[:selected_products].present?
      params[:selected_products].keys.each do |product_id|
        product = Product.find(product_id)
        @building_block.products.push(product)
      end
    end

    if params[:selected_workflows].present?
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

    if policy(@building_block).beta_only?
      if building_block_params[:maturity] != BuildingBlock.entity_status_types[:BETA] &&
          session[:building_block_elevated_role].to_s.downcase != 'true'
        session[:building_block_elevated_role] = true
      end

      # Always override to beta if the user don't have the right role
      @building_block.maturity = BuildingBlock.entity_status_types[:BETA]
    end

    respond_to do |format|
      if !@building_block.errors.any? && @building_block.save
        if building_block_params[:bb_desc].present?
          @bb_desc.building_block_id = @building_block.id
          @bb_desc.locale = I18n.locale
          @bb_desc.description = JSON.parse(building_block_params[:bb_desc])
          @bb_desc.save
        end
        format.html { redirect_to @building_block,
                      flash: { notice: t('messages.model.created', model: t('model.building-block').to_s.humanize) }}
        format.json { render :show, status: :created, location: @building_block }
      else
        error_message = ""
        @building_block.errors.each do |_attr, err|
          error_message = err
        end
        format.html { redirect_to new_building_block_url, flash: { error: error_message } }
        format.json { render json: @building_block.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /building_blocks/1
  # PATCH/PUT /building_blocks/1.json
  def update
    authorize @building_block, :mod_allowed?

    products = Set.new
    if params[:selected_products].present?
      params[:selected_products].keys.each do |product_id|
        product = Product.find(product_id)
        products.add(product)
      end
    end
    @building_block.products = products.to_a

    workflows = Set.new
    if params[:selected_workflows].present?
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

    if building_block_params[:bb_desc].present?
      @bb_desc.building_block_id = @building_block.id
      @bb_desc.locale = I18n.locale
      @bb_desc.description = JSON.parse(building_block_params[:bb_desc])
      @bb_desc.save
    end

    if policy(@building_block).beta_only?
      if building_block_params[:maturity] != BuildingBlock.entity_status_types[:BETA] &&
          session[:building_block_elevated_role].to_s.downcase != 'true'
        session[:building_block_elevated_role] = true
      end

      # Always override to beta if the user don't have the right role
      @building_block.maturity = BuildingBlock.entity_status_types[:BETA]
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
    authorize(@building_block, :delete_allowed?)
    @building_block.destroy
    respond_to do |format|
      format.html { redirect_to building_blocks_url,
                    flash: { notice: t('messages.model.deleted', model: t('model.building-block').to_s.humanize) }}
      format.json { head :no_content }
    end
  end

  def duplicates
    @building_blocks = []
    if params[:current].present?
      current_slug = slug_em(params[:current])
      original_slug = slug_em(params[:original])
      if current_slug != original_slug
        @building_blocks = BuildingBlock.where(slug: current_slug).to_a
      end
    end
    authorize BuildingBlock, :view_allowed?
    render json: @building_blocks, only: [:name]
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_building_block
      if !params[:id].scan(/\D/).empty?
        @building_block = BuildingBlock.find_by(slug: params[:id]) or not_found
      else
        @building_block = BuildingBlock.find_by(id: params[:id]) or not_found
      end
      @bb_desc = BuildingBlockDescription.where(building_block_id: @building_block, locale: I18n.locale).first
      if !@bb_desc
        @bb_desc = BuildingBlockDescription.new
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def building_block_params
      params
        .require(:building_block)
        .permit(:name, :confirmation, :bb_desc, :slug, :maturity)
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
