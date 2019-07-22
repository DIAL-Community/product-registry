class ProductsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
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
    @products = Product.eager_load(:references, :include_relationships, :interop_relationships, :building_blocks, :sustainable_development_goals, :sectors).order(:name)
    if params[:without_paging]
      @products = @products
          .name_contains(params[:search])
      authorize @products, :view_allowed?
      return
    end

    if params[:search]
      @products = @products
          .where(nil)
          .name_contains(params[:search])
    end
    authorize @products, :view_allowed?
  end

  # GET /products/1
  # GET /products/1.json
  def show
    authorize @product, :view_allowed?
    # All of this data will be passed to the launch partial and used by javascript
    @jenkins_url = Rails.configuration.jenkins["jenkins_url"]
    @jenkins_user = Rails.configuration.jenkins["jenkins_user"]
    @jenkins_password = Rails.configuration.jenkins["jenkins_password"]
  end

  # GET /products/new
  def new
    authorize Product, :mod_allowed?
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
    authorize @product, :mod_allowed?
  end

  # POST /products
  # POST /products.json
  def create
    authorize Product, :mod_allowed?
    @product = Product.new(product_params)

    if product_params[:start_assessment] == "true"
      assign_maturity
    end

    if (params[:selected_organizations])
      params[:selected_organizations].keys.each do |organization_id|
        organization = Organization.find(organization_id)
        @products.organizations.push(organization)
      end
    end

    if (params[:selected_sectors].present?)
      params[:selected_sectors].keys.each do |sector_id|
        sector = Sector.find(sector_id)
        @products.sectors.push(sector)
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

    if (params[:selected_sustainable_development_goals])
      params[:selected_sustainable_development_goals].keys.each do |sustainable_development_goal_id|
        sustainable_development_goal = SustainableDevelopmentGoal.find(sustainable_development_goal_id)
        @product.sustainable_development_goals.push(sustainable_development_goal)
      end
    end

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, flash: { notice: 'Product was successfully created.' }}
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

    authorize @product, :mod_allowed?
    if (!product_params[:start_assessment].nil? && product_params[:start_assessment] == "true") || @product.start_assessment
      assign_maturity
    end

    organizations = Set.new
    if (params[:selected_organizations])
      params[:selected_organizations].keys.each do |organization_id|
        organization = Organization.find(organization_id)
        organizations.add(organization)
      end
    end
    @product.organizations = organizations.to_a

    sectors = Set.new
    if (params[:selected_sectors].present?)
      params[:selected_sectors].keys.each do |sector_id|
        sector = Sector.find(sector_id)
        sectors.add(sector)
      end
    end
    @product.sectors = sectors.to_a

    products = Set.new
    if (params[:selected_interoperable_products])
      params[:selected_interoperable_products].keys.each do |product_id|
        product = Product.find(product_id)
        products.add(product)
      end
    end
    @product.interoperates_with = products.to_a

    products = Set.new
    if (params[:selected_included_products])
      params[:selected_included_products].keys.each do |product_id|
        product = Product.find(product_id)
        products.add(product)
      end
    end
    @product.includes = products.to_a

    building_blocks = Set.new
    if (params[:selected_building_blocks])
      params[:selected_building_blocks].keys.each do |building_block_id|
        building_block = BuildingBlock.find(building_block_id)
        building_blocks.add(building_block)
      end
    end
    @product.building_blocks = building_blocks.to_a

    sustainable_development_goals = Set.new
    if (params[:selected_sustainable_development_goals])
      params[:selected_sustainable_development_goals].keys.each do |sustainable_development_goal_id|
        sustainable_development_goal = SustainableDevelopmentGoal.find(sustainable_development_goal_id)
        sustainable_development_goals.add(sustainable_development_goal)
      end
    end
    @product.sustainable_development_goals = sustainable_development_goals.to_a

    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, flash: { notice: 'Product was successfully updated.' }}
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
    authorize @product, :mod_allowed?
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, flash: { notice: 'Product was successfully destroyed.' }}
      format.json { head :no_content }
    end
  end

  def duplicates
    @products = Array.new
    if params[:current].present?
      current_slug = slug_em(params[:current]);
      original_slug = slug_em(params[:original]);
      if (current_slug != original_slug)
        @products = Product.(slug: current_slug).to_a
      end
    end
    authorize @products, :view_allowed?
    render json: @products, :only => [:name]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      if !params[:id].scan(/\D/).empty?
        @product = Product.find_by(slug: params[:id])
      else
        @product = Product.find(params[:id])
      end
    end

    def load_maturity
      @osc_maturity = YAML.load_file("config/maturity_osc.yml")
      @digisquare_maturity = YAML.load_file("config/maturity_digisquare.yml")
    end

    def assign_maturity
      @product.product_assessment ||= ProductAssessment.new
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
        .permit(:name, :website, :is_launchable, :start_assessment, :aliases)
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
