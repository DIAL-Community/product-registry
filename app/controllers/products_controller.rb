class ProductsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :load_maturity, only: [:show, :new, :edit, :create, :update]

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

    @products = filter_products.order(:name)
    authorize @products, :view_allowed?
  end

  def count
    @products = filter_products

    authorize @products, :view_allowed?
    render json: @products.count
  end

  # GET /products/1
  # GET /products/1.json
  def show
    authorize @product, :view_allowed?
    # All of this data will be passed to the launch partial and used by javascript
    @jenkins_url = Rails.application.secrets.jenkins_url
    @jenkins_user = Rails.application.secrets.jenkins_user
    @jenkins_password = Rails.application.secrets.jenkins_password
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

    if params[:logo].present?
      uploader = LogoUploader.new(@product, params[:logo].original_filename, current_user)
      uploader.store!(params[:logo])
    end

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product,
                      flash: { notice: t('messages.model.created', model: t('model.product').to_s.humanize) }}
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

    if params[:logo].present?
      uploader = LogoUploader.new(@product, params[:logo].original_filename, current_user)
      uploader.store!(params[:logo])
    end

    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product,
                      flash: { notice: t('messages.model.updated', model: t('model.product').to_s.humanize) }}
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
      format.html { redirect_to products_url,
                    flash: { notice: t('messages.model.deleted', model: t('model.product').to_s.humanize) }}
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

      if (@products.empty?)
        @products = Product.where(":other_name = ANY(aliases)", other_name: params[:current])
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

  def filter_products
    use_cases = sanitize_session_values 'use_cases'
    workflows = sanitize_session_values 'workflows'
    sdgs = sanitize_session_values 'sdgs'
    bbs = sanitize_session_values 'building_blocks'
    products = sanitize_session_values 'products'
    origins = sanitize_session_values 'origins'

    with_maturity_assessment = sanitize_session_value 'with_maturity_assessment'

    filter_set = !(sdgs.empty? && use_cases.empty? && workflows.empty? && bbs.empty? && products.empty? && origins.empty?)

    sdg_products = Product.none
    if !sdgs.empty?
      sdg_products = Product.all.joins(:sustainable_development_goals).where('sustainable_development_goal_id in (?)', sdgs)

      # Get use_cases connected to this sdg
      sdg_targets = SdgTarget.all.where('sdg_number in (?)', sdgs)
      sdg_use_cases = UseCase.all.where('id in (select use_case_id from use_cases_sdg_targets where sdg_target_id in (?))', sdg_targets.ids)
    end

    if sdg_use_cases
      combined_use_cases = (use_cases + sdg_use_cases).uniq
    else
      combined_use_cases = use_cases
    end

    if !combined_use_cases.empty?
      # Get workflows connected to this use case
      use_case_workflows = Workflow.all.joins(:use_cases).where('use_case_id in (?)', combined_use_cases).distinct
    end

    if use_case_workflows
      combined_workflows = (workflows + use_case_workflows).uniq
    else
      combined_workflows = workflows
    end

    bb_workflows = BuildingBlock.none
    if !combined_workflows.empty? || use_case_workflows
      bb_workflows = BuildingBlock.all.joins(:workflows).where('workflow_id in (?)', combined_workflows).distinct
    end

    bb_ids = (bb_workflows + bbs).uniq
    bb_products = Product.none
    if !bb_ids.empty?
      bb_products = Product.all.joins(:building_blocks).where('building_block_id in (?)', bb_ids)
    end

    origin_products = Product.none
    if !origins.empty?
      origin_products = Product.joins(:origins).where('origin_id in (?)', origins).distinct
    end

    with_maturity_products = Product.none
    if with_maturity_assessment
      with_maturity_products = Product.joins(:product_assessment).where('has_osc = true or has_digisquare = true')
    end

    if filter_set || with_maturity_assessment
      product_ids = (sdg_products + bb_products + origin_products + with_maturity_products + products).uniq
      products = Product.where(id: product_ids)
    else
      products = Product.all.order(:slug)
    end
    products
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
          product_assessment[digisquare_maturity] = ProductAssessment.digisquare_maturity_levels.key(params[:digisquare_maturity][digisquare_maturity])
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
        .permit(:name, :website, :is_launchable, :default_url, :has_osc, :osc_maturity, :has_digisquare,
                :start_assessment, :digisquare_maturity, :confirmation, :slug, :logo)
        .tap do |attr|
          if (params[:other_names].present?)
            attr[:aliases] = params[:other_names].reject {|x|x.empty?}
          end
          if (params[:reslug].present?)
            attr[:slug] = slug_em(attr[:name])
            if (params[:duplicate].present?)
              first_duplicate = Product.slug_starts_with(attr[:slug]).order(slug: :desc).first
              attr[:slug] = attr[:slug] + generate_offset(first_duplicate).to_s
            end
          end
        end
    end
end
