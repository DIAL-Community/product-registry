class BuildingBlocksController < ApplicationController
  before_action :set_building_block, only: [:show, :edit, :update, :destroy]

  # GET /building_blocks
  # GET /building_blocks.json
  def index
    if params[:without_paging]
      @building_blocks = BuildingBlock
          .starts_with(params[:search])
          .order(:name)
      return
    end

    if params[:search]
      @building_blocks = BuildingBlock
          .where(nil)
          .starts_with(params[:search])
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
  end

  # POST /building_blocks
  # POST /building_blocks.json
  def create
    @building_block = BuildingBlock.new(building_block_params)

    respond_to do |format|
      if @building_block.save
        format.html { redirect_to @building_block, notice: 'Building block was successfully created.' }
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_building_block
      @building_block = BuildingBlock.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def building_block_params
      params.require(:building_block).permit(:name, :slug)
    end
end
