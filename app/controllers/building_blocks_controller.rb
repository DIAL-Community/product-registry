class BuildingBlocksController < ApplicationController
  before_action :set_building_block, only: [:show, :edit, :update, :destroy]

  # GET /building_blocks
  # GET /building_blocks.json
  def index
    if params[:without_paging]
      @building_blocks = BuildingBlock
        .name_contains(params[:search])
        .order(:name)
      return
    end

    if params[:search]
      @building_blocks = BuildingBlock
        .where(nil)
        .name_contains(params[:search])
        .order(:name)
        .paginate(page: params[:page], per_page: 20)
    else
      @building_blocks = BuildingBlock
        .order(:name)
        .paginate(page: params[:page], per_page: 20)
    end
  end

  # GET /building_blocks/1
  # GET /building_blocks/1.json
  def show
  end

  # GET /building_blocks/new
  def new
    @building_block = BuildingBlock.new
  end

  # GET /building_blocks/1/edit
  def edit
    if (params[:product_id])
      @product = Product.find(params[:product_id])
    end
  end

  # POST /building_blocks
  # POST /building_blocks.json
  def create
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

    respond_to do |format|
      if @building_block.save
        format.html { redirect_to @building_block, notice: 'Building Block was successfully created.' }
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

    respond_to do |format|
      if @building_block.update(building_block_params)
        format.html { redirect_to @building_block, notice: 'Building block was successfully updated.' }
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
    @building_block.destroy
    respond_to do |format|
      format.html { redirect_to building_blocks_url, notice: 'Building block was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def duplicates
    @building_block = Array.new
    if params[:current].present?
      current_slug = slug_em(params[:current]);
      original_slug = slug_em(params[:original]);
      if (current_slug != original_slug)
        @building_block = BuildingBlock.where(slug: current_slug).to_a
      end
    end
    render json: @building_block, :only => [:name]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_building_block
      @building_block = BuildingBlock.find(params[:id])
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
              attr[:slug] = attr[:slug] + "_" + calculate_offset(first_duplicate).to_s
            end
          end
        end
    end
end
