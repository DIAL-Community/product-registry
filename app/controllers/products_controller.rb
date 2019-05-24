class ProductsController < ApplicationController
  before_action :authenticate_user!, only: [:show, :new, :create, :edit, :update, :destroy]
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :load_maturity, only: [:show, :new, :edit, :create]

  def map
    @products = Product.order(:slug).eager_load(:references, :include_relationships, :interop_relationships)
    @product_relationships = ProductProductRelationship.order(:id).eager_load(:from_product, :to_product)
    render layout: 'layouts/raw'
  end

  # GET /products
  # GET /products.json
  def index
    if params[:without_paging]
      @products = Product
          .name_contains(params[:search])
          .order(:slug)
      return
    end

    if params[:search]
      @products = Product
          .where(nil)
          .name_contains(params[:search])
          .eager_load(:references, :include_relationships, :interop_relationships, :building_blocks)
          .order(:slug)
          #.paginate(page: params[:page], per_page: 20)
    else
      @products = Product
          .eager_load(:references, :include_relationships, :interop_relationships, :building_blocks)
          .order(:slug)
          #.paginate(page: params[:page], per_page: 20)
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

  def launch
    jenkins_url = Rails.configuration.jenkins["jenkins_url"]
    jenkins_user = Rails.configuration.jenkins["jenkins_user"]
    jenkins_password = Rails.configuration.jenkins["jenkins_password"]
    build_name = params[:product_id]
    logger.debug build_name

    @launched = true
    @launch_message = "Product is being launched on Digital Ocean droplet"

    # First, get the crumb that we need to validate the build
    url = jenkins_url+"/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,%22:%22,//crumb)"
    logger.debug url
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth(jenkins_user, jenkins_password)
    response = http.request(request)

    crumb_parts=response.body.split(':')
    jenkins_crumb=crumb_parts[1]
    logger.debug jenkins_crumb

    # Add Jenkins-Crumb and crumb value to request header, Content-Type=text/xml
    url=jenkins_url+"/job/"+build_name+"/build"
    uri = URI(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri, {'Content-Type' => 'application/json', 'Jenkins-Crumb' => jenkins_crumb})
    request.basic_auth(jenkins_user, jenkins_password)
    response = http.request(request)

    respond_to do |format|               
      format.js
    end
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    @product.product_assessment ||= ProductAssessment.new
    assign_maturity

    if (params[:selected_sectors].present?)
      params[:selected_sectors].keys.each do |sector_id|
        @sector = Sector.find(sector_id)
        @organization.sectors.push(@sector)
      end
    end

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

    if (params[:selected_sectors].present?)
      sectors = Set.new
      params[:selected_sectors].keys.each do |sector_id|
        sector = Sector.find(sector_id)
        sectors.add(sector)
      end
      @product.sectors = sectors.to_a
    end

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
        .permit(:name, :website, :is_launchable, :docker_image, :has_osc, :osc_maturity, :has_digisquare,
                :digisquare_maturity, :confirmation)
        .tap do |attr|
          if (params[:reslug].present?)
            attr[:slug] = slug_em(attr[:name])
            if (params[:duplicate].present?)
              first_duplicate = Product.slug_starts_with(attr[:slug]).order(slug: :desc).first
              attr[:slug] = attr[:slug] + "_" + calculate_offset(first_duplicate).to_s
            end
          end
        end
    end
end
