class ProductsController < ApplicationController
  before_action :authenticate_user!, only: [:show, :new, :create, :edit, :update, :destroy]
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :load_maturity, only: [:show, :new, :edit, :create]

  # GET /products
  # GET /products.json
  def index
    if params[:without_paging]
      @products = Product
          .name_contains(params[:search])
          .order(:name)
      return
    end

    if params[:search]
      @products = Product
          .where(nil)
          .name_contains(params[:search])
          .order(:name)
          .paginate(page: params[:page], per_page: 20)
    else
      @products = Product
          .order(:name)
          .paginate(page: params[:page], per_page: 20)
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
    @product.product_assessment ||= ProductAssessment.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    @product.product_assessment ||= ProductAssessment.new
    assign_maturity

    if (params[:selected_interoperable_products])
      params[:selected_interoperable_products].keys.each do |product_id|
        to_product = Product.find(product_id)
        @product.interoperates_with.push(to_product)
      end
    end

    if (params[:selected_included_products])
      params[:selected_included_products].keys.each do |product_id|
        to_product = Product.find(product_id)
        @product.includes.push(to_product)
      end
    end

    if (params[:selected_building_blocks])
      params[:selected_building_blocks].keys.each do |building_block_id|
        building_block = BuildingBlock.find(building_block_id)
        @product.building_blocks.push(building_block)
      end
    end

    can_be_saved = @product.valid?
    if (!can_be_saved && !params[:confirmation].nil?)
      size = Product.slug_starts_with(@product.slug).size
      @product.slug = @product.slug + '_' + size.to_s
      can_be_saved = true
    end

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    assign_maturity

    if (params[:selected_interoperable_products])
      products = Set.new
      params[:selected_interoperable_products].keys.each do |product_id|
        product = Product.find(product_id)
        products.add(product)
      end
      @product.interoperates_with = products.to_a
    end

    if (params[:selected_included_products])
      products = Set.new
      params[:selected_included_products].keys.each do |product_id|
        product = Product.find(product_id)
        products.add(product)
      end
      @product.includes = products.to_a
    end

    if (params[:selected_building_blocks])
      building_blocks = Set.new
      params[:selected_building_blocks].keys.each do |building_block_id|
        building_block = BuildingBlock.find(building_block_id)
        building_blocks.add(building_block)
      end
      @product.building_blocks = building_blocks.to_a
    end

    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def duplicates
    @products = Array.new
    if params[:current].present?
      current_slug = slug_em(params[:current]);
      original_slug = slug_em(params[:original]);
      if (current_slug != original_slug)
        @products = Product.where(slug: current_slug).to_a
      end
    end
    render json: @products, :only => [:name]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
      @product.product_assessment ||= ProductAssessment.new
    end

    def load_maturity
      @osc_maturity = YAML.load_file("config/maturity_osc.yml")
      @digisquare_maturity = YAML.load_file("config/maturity_digisquare.yml")
    end

    def assign_maturity
      product_assessment = @product.product_assessment
      if (params[:osc_maturity])
        params[:osc_maturity].keys.each do |osc_maturity|
          product_assessment[osc_maturity] = (params[:osc_maturity][osc_maturity] == "true")
        end
      end
      if (params[:digisquare_maturity])
        params[:digisquare_maturity].keys.each do |digisquare_maturity|
          product_assessment[digisquare_maturity] = params[:digisquare_maturity][digisquare_maturity]
        end
      end
      product_assessment.has_osc = (params[:has_osc] == "true")
      product_assessment.has_digisquare = (params[:has_digisquare] == "true")

      @product.product_assessment = product_assessment
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params
        .require(:product)
        .permit(:name, :website, :has_osc, :osc_maturity, :has_digisquare, :digisquare_maturity, :confirmation)
        .tap do |attr|
          if (attr[:name].present?)
            attr[:slug] = slug_em(attr[:name])
          end
        end
    end
end
