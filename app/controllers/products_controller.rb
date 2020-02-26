class ProductsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :load_maturity, only: [:show, :new, :edit, :create, :update]
  before_action :set_current_user, only: [:edit, :update, :destroy]

  def map
    @products = Product.order(:slug).eager_load(:references, :include_relationships, :interop_relationships)
    @product_relationships = ProductProductRelationship.order(:id).eager_load(:from_product, :to_product)
    render layout: 'layouts/raw'
  end

  # GET /products
  # GET /products.json
  def index
    if params[:without_paging]
      @products = Product.name_contains(params[:search]).order(Product.arel_table['name'].lower.asc)
      authorize @products, :view_allowed?
      return
    end

    @products = filter_products.order(Product.arel_table['name'].lower.asc)
    @products = @products.eager_load(:references, :include_relationships, :includes, :interop_relationships,
                                     :interoperates_with, :product_assessment, :origins, :organizations,
                                     :building_blocks, :sustainable_development_goals, :sectors)
                         .order(:name)

    params[:search].present? && @products = @products.name_contains(params[:search])
    authorize @products, :view_allowed?
  end

  def count
    @products = filter_products.distinct
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
    @product_description = ProductDescription.new
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
    @product.set_current_user(current_user)
    @product_description = ProductDescription.new

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
        new_prod_sdg = ProductsSustainableDevelopmentGoal.new
        new_prod_sdg.sustainable_development_goal_id = sustainable_development_goal_id
        new_prod_sdg.link_type = 'Validated'

        @product.products_sustainable_development_goals << new_prod_sdg
      end
    end

    if params[:logo].present?
      uploader = LogoUploader.new(@product, params[:logo].original_filename, current_user)
      begin
        uploader.store!(params[:logo])
      rescue StandardError => e
        @product.errors.add(:logo, t('errors.messages.extension_whitelist_error'))
      end
      @product.set_image_changed(params[:logo].original_filename)
    end

    respond_to do |format|
      if !@product.errors.any? && @product.save

        if product_params[:product_description].present?
          @product_description.product_id = @product.id
          @product_description.locale = I18n.locale
          @product_description.description = JSON.parse(product_params[:product_description])
          @product_description.save
        end

        format.html { redirect_to @product,
                      flash: { notice: t('messages.model.created', model: t('model.product').to_s.humanize) }}
        format.json { render :show, status: :created, location: @product }
      else
        errMsg = ""
        @product.errors.each do |attr, err|
          errMsg = err
        end
        format.html { redirect_to new_product_url, flash: { error: errMsg } }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    authorize @product, :mod_allowed?
    if (!product_params[:start_assessment].nil? && product_params[:start_assessment] == 'true') || @product.start_assessment
      assign_maturity
    end

    organizations = Set.new
    if params[:selected_organizations].present?
      params[:selected_organizations].keys.each do |organization_id|
        organization = Organization.find(organization_id)
        organizations.add(organization)
      end
    end
    @product.organizations = organizations.to_a

    sectors = Set.new
    if params[:selected_sectors].present?
      params[:selected_sectors].keys.each do |sector_id|
        sector = Sector.find(sector_id)
        sectors.add(sector)
      end
    end
    @product.sectors = sectors.to_a

    products = Set.new
    if params[:selected_interoperable_products].present?
      params[:selected_interoperable_products].keys.each do |product_id|
        product = Product.find(product_id)
        products.add(product)
      end
    end
    @product.interoperates_with = products.to_a

    products = Set.new
    if params[:selected_included_products].present?
      params[:selected_included_products].keys.each do |product_id|
        product = Product.find(product_id)
        products.add(product)
      end
    end
    @product.includes = products.to_a

    building_blocks = Set.new
    if params[:selected_building_blocks].present?
      params[:selected_building_blocks].keys.each do |building_block_id|
        building_block = BuildingBlock.find(building_block_id)
        building_blocks.add(building_block)
      end
    end
    @product.building_blocks = building_blocks.to_a

    product_sdgs = []
    @product.sustainable_development_goals.delete_all
    if params[:selected_sustainable_development_goals].present?
      params[:selected_sustainable_development_goals].each do |selected_sdg|
        curr_sdg = @product.products_sustainable_development_goals.find_by(sustainable_development_goal_id: selected_sdg)
        if curr_sdg.nil?
          new_prod_sdg = ProductsSustainableDevelopmentGoal.new
          new_prod_sdg.sustainable_development_goal_id = selected_sdg
          new_prod_sdg.link_type = 'Validated'

          product_sdgs.push(new_prod_sdg)
        end
      end
      @product.products_sustainable_development_goals << product_sdgs
    end

    if params[:logo].present?
      uploader = LogoUploader.new(@product, params[:logo].original_filename, current_user)
      begin
        uploader.store!(params[:logo])
      rescue StandardError => e
        @product.errors.add(:logo, t('errors.messages.extension_whitelist_error'))
      end
      @product.set_image_changed(params[:logo].original_filename)
    end

    if product_params[:product_description].present?
      @product_description.product_id = @product.id
      @product_description.locale = I18n.locale
      @product_description.description = JSON.parse(product_params[:product_description])
      @product_description.save
    end

    respond_to do |format|
      if @product.errors.none? && @product.update(product_params)
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

  def productlist
    @products = Array.new
    
    product_list = Product.all.eager_load(:sustainable_development_goals, :sectors, :organizations, :origins)

    curr_products = product_list.map do |product|
      origin_list = product.origins.map do |origin|
        origin.slug
      end
      next if params[:source] && !origin_list.include?(params[:source])
      
      sdg_list = product.sustainable_development_goals.map do |sdg|
        [ sdg.number, sdg.name ]
      end

      sector_list = product.sectors.map do |sector|
        sector.name
      end

      org_list = product.organizations.map do |org|
        org_prod = OrganizationsProduct.where(product_id: product, organization_id: org).first
        { :name => org.name, :website => org.website, :org_type => org_prod.org_type }
      end

      license_file = ""
      if !product.license_analysis.nil?
        license_data = product.license_analysis.split(/\r?\n/)
        license_data.each do |license_line|
          if license_line.include?("Matched files")
            license_files = license_line.split(':')[1]
            if license_files.include?(',')
              license_file = "https://"+product.repository + '/' + license_files.split(',').first.gsub(/\s+/, "")
            else
              license_file = "https://"+product.repository + '/' + license_files.gsub(/\s+/, "")
            end
            puts license_file
          end
        end
      end

      description = ProductDescription.where(product_id: product, locale: I18n.locale).first

      product_description = ""
      if !description.nil?
        desc_json = description['description']
        if !desc_json['ops'].nil?
          product_description = desc_json['ops'][0]['insert']
        end
      end

      repositoryURL=""
      if !product.repository.nil?
        repositoryURL = "https://"+product.repository
      end
      
      { :name => product.name, :description => product_description, :license => [{:spdx => product.license, :licenseURL => license_file}], :SDGs => sdg_list.as_json, :sectors => sector_list.as_json, :type => "software", :repositoryURL => repositoryURL, :organizations => org_list.as_json }
    end

    curr_products.each do |prod|
      if !prod.nil?
        @products.push(prod)
      end
    end

    render json: @products
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_product
      if !params[:id].scan(/\D/).empty?
        @product = Product.find_by(slug: params[:id]) or not_found
      else
        @product = Product.find_by(id: params[:id]) or not_found
      end
      @product_description = ProductDescription.where(product_id: @product, locale: I18n.locale)
                                               .first
      if @product_description.nil?
        @product_description = ProductDescription.new
      end
    end

    def set_current_user
      @product.set_current_user(current_user)
    end

    def filter_products
      bbs = sanitize_session_values 'building_blocks'
      origins = sanitize_session_values 'origins'
      products = sanitize_session_values 'products'
      sdgs = sanitize_session_values 'sdgs'
      use_cases = sanitize_session_values 'use_cases'
      workflows = sanitize_session_values 'workflows'
      organizations = sanitize_session_values 'organizations'

      with_maturity_assessment = sanitize_session_value 'with_maturity_assessment'
      is_launchable = sanitize_session_value 'is_launchable'

      filter_set = !(sdgs.empty? && use_cases.empty? && workflows.empty? && bbs.empty? && products.empty? && origins.empty? && organizations.empty?)

      org_products = Product.all
      if !organizations.empty?
        org_products = Product.all.joins(:organizations).where('organization_id in (?)', organizations)
      end 

      sdg_products = org_products
      if !sdgs.empty?
        sdg_products = org_products.joins(:sustainable_development_goals).where('sustainable_development_goal_id in (?)', sdgs)
      end

      use_case_bbs = get_bbs_from_use_cases(use_cases)
      workflow_bbs = get_bbs_from_workflows(workflows)

      if (!bbs.empty?)
        filter_bbs = BuildingBlock.all.where('id in (?)', bbs)
        bb_ids = (filter_bbs.ids & use_case_bbs & workflow_bbs).uniq
      else 
        bb_ids = (use_case_bbs & workflow_bbs).uniq
      end

      bb_products = Product.all
      if !use_cases.empty? || ! workflows.empty? || !bbs.empty?
        bb_products = Product.all.where('id in (select product_id from products_building_blocks where building_block_id in (?))', bb_ids)
      end

      product_ids, product_filter_set = get_products_from_filters(products, origins, with_maturity_assessment, is_launchable)

      if filter_set || product_filter_set
        product_ids = (sdg_products.ids & bb_products.ids & product_ids).uniq
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
        .permit(policy(Product).permitted_attributes)
        .tap do |attr|
          if attr[:website].present?
            # Handle both:
            # * http:// or https://
            # * (and the typo) http//: or https//:
            attr[:website] = attr[:website].strip
                                           .sub(/^https?\:\/\//i, '')
                                           .sub(/^https?\/\/\:/i, '')
                                           .sub(/\/$/, '')
          end
          if attr[:repository].present?
            attr[:repository] = attr[:repository].strip
                                                 .sub(/^https?\:\/\//i, '')
                                                 .sub(/^https?\/\/\:/i, '')
                                                 .sub(/\/$/, '')
          end
          if params[:other_names].present? && policy(Product).permitted_attributes.include?(:aliases)
            attr[:aliases] = params[:other_names].reject(&:empty?)
          end
          if params[:reslug].present? && policy(Product).permitted_attributes.include?(:slug)
            attr[:slug] = slug_em(attr[:name])
            if params[:duplicate].present?
              first_duplicate = Product.slug_starts_with(attr[:slug]).order(slug: :desc).first
              attr[:slug] = attr[:slug] + generate_offset(first_duplicate).to_s
            end
          end
        end
    end
end
