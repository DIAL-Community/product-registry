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
      @products = Product.name_contains(params[:search])
                         .order(Product.arel_table['name'].lower.asc)
      authorize @products, :view_allowed?
      return
    end

    # :filtered_time will be updated every time we add or remove a filter.
    if session[:filtered_time].to_s.downcase != session[:product_filtered_time].to_s.downcase
      # :product_filtered_time is not updated after the filter is updated:
      # - rebuild the product id cache
      logger.info('Filter updated. Rebuilding cached product id list.')

      product_ids, filter_set = filter_products
      session[:product_filtered_ids] = product_ids
      session[:product_filtered] = filter_set
      session[:product_filtered_time] = session[:filtered_time]
    end

    # Current page information will be stored in the main page div.
    current_page = params[:page] || 1

    @products = Product.where(is_child: false)
    if session[:product_filtered].to_s.downcase == 'true'
      @products = @products.where(id: session[:product_filtered_ids])
    end

    if params[:covid].present? && params[:covid].to_s.downcase == 'true'
      covid19_tag = Setting.find_by(slug: 'default_covid19_tag')
      @products = @products.where(':tag = ANY(products.tags)', tag: covid19_tag.value.downcase)
    end

    if params[:search].present?
      name_products = @products.name_contains(params[:search])
      desc_products = @products.joins(:product_descriptions)
                               .where("LOWER(description#>>'{}') like LOWER(?)", "%#{params[:search]}%")
      @products = @products.where(id: (name_products + desc_products).uniq)
    end

    @products = @products.eager_load(:includes, :interoperates_with, :product_assessment, :origins, :organizations,
                                     :building_blocks, :sustainable_development_goals)
                         .paginate(page: current_page, per_page: 20)
                         .order(:name)

    authorize @products, :view_allowed?
  end

  def count
    # We will use whichever set the product id cache first: this one or the one in index method.
    # This should reduce the need to execute the same operation multiple time.
    if session[:filtered_time].to_s.downcase != session[:product_filtered_time].to_s.downcase
      product_ids, filter_set = filter_products
      session[:product_filtered_ids] = product_ids
      session[:product_filtered] = filter_set
      session[:product_filtered_time] = session[:filtered_time]
    end

    product_count = Product.where(is_child: false)
    if session[:product_filtered].to_s.downcase == 'true'
      product_count = product_count.where(id: session[:product_filtered_ids])
    end

    authorize Product, :view_allowed?
    render json: product_count.count
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

    if params[:selected_sustainable_development_goals].present?
      existing_sdgs = ProductsSustainableDevelopmentGoal.where(product_id: @product.id)
                                                        .pluck('sustainable_development_goal_id')
      ui_sdgs = params[:selected_sustainable_development_goals].keys
                                                               .map(&:to_i)
      removed_sdgs = existing_sdgs - ui_sdgs
      logger.debug("Removing: #{removed_sdgs} product - sdgs relationship.")
      removed_sdgs.each do |sdg_id|
        ProductsSustainableDevelopmentGoal.where(product_id: @product.id,
                                                 sustainable_development_goal_id: sdg_id)
                                          .delete_all
      end

      added_sdgs = ui_sdgs - existing_sdgs
      logger.debug("Adding: #{added_sdgs} product - sdgs relationship")
      added_sdgs.each do |sdg_id|
        new_prod_sdg = ProductsSustainableDevelopmentGoal.new
        new_prod_sdg.sustainable_development_goal_id = sdg_id
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

      if @products.empty?
        @products = Product.where(':other_name = ANY(aliases)', other_name: params[:current])
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

      sdg_list = product.sustainable_development_goals.order(:number).map do |sdg|
        [ sdg.number, sdg.name ]
      end

      sector_list = product.sectors.map do |sector|
        sector.name
      end

      org_list = product.organizations.map do |org|
        org_prod = OrganizationsProduct.where(product_id: product, organization_id: org).first
        { :name => org.name, :website => 'https://'+org.website.to_s, :org_type => org_prod.org_type }
      end

      license_file = ""
      if !product.license_analysis.nil?
        license_data = product.license_analysis.split(/\r?\n/)
        license_data.each do |license_line|
          if license_line.include?("Matched files")
            license_files = license_line.split(':')[1]
            if license_files.include?(',')
              license_file = product.repository + '/' + license_files.split(',').first.gsub(/\s+/, "")
            else
              license_file = product.repository + '/' + license_files.gsub(/\s+/, "")
            end
          end
        end
      end

      description = ProductDescription.where(product_id: product, locale: I18n.locale).first

      product_description = ""
      if !description.nil?
        desc_json = description["description"].to_s
        if !desc_json.nil?
          desc = desc_json.split(':')[2]
          if !desc.nil?
            desc = desc.gsub("}]}","").tr('"','')
            product_description = desc
          end
        end
      end

      repositoryURL=""
      if !product.repository.nil?
        repositoryURL = product.repository
      end

      #puts "WEBSITE: " + product.website
      { :name => product.name, :description => product_description, :website => 'https://'+product.website.to_s, :license => [{:spdx => product.license, :licenseURL => license_file}], :SDGs => sdg_list.as_json, :sectors => sector_list.as_json, :type => [ "software" ], :repositoryURL => repositoryURL, :organizations => org_list.as_json }
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
      @child_products = Product.where(parent_product_id: @product)
      if !@child_products.empty?
        @child_descriptions = ProductDescription.where(product_id: @child_products)
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
      projects = sanitize_session_values 'projects'

      endorser_only = sanitize_session_value 'endorser_only'
      aggregator_only = sanitize_session_value 'aggregator_only'
      years = sanitize_session_values 'years'

      with_maturity_assessment = sanitize_session_value 'with_maturity_assessment'
      is_launchable = sanitize_session_value 'is_launchable'

      countries = sanitize_session_values 'countries'
      sectors = sanitize_session_values 'sectors'

      tags = sanitize_session_values 'tags'

      filter_set = !(countries.empty? && products.empty? && sectors.empty? && years.empty? &&
                     organizations.empty? && origins.empty? && projects.empty? && tags.empty? &&
                     sdgs.empty? && use_cases.empty? && workflows.empty? && bbs.empty?) ||
                   endorser_only || aggregator_only || with_maturity_assessment || is_launchable

      return [[], filter_set] unless filter_set

      project_product_ids = []
      !projects.empty? && project_product_ids = Product.joins(:projects)
                                                       .where('projects.id in (?)', projects)
                                                       .ids

      # Filter out organizations based on filter input.
      org_ids = get_organizations_from_filters(organizations, years, sectors, countries, endorser_only, aggregator_only)
      org_filtered = (!years.empty? || !organizations.empty? || endorser_only || aggregator_only ||
                      !sectors.empty? || !countries.empty?)

      # Filter out project based on organization filter above.
      org_projects = []
      org_filtered && org_projects += Project.joins(:organizations)
                                             .where('organizations.id in (?)', org_ids)
                                             .ids

      # Add products based on the project filtered above.
      !org_projects.empty? && project_product_ids += Product.joins(:projects)
                                                            .where('projects.id in (?)', org_projects)
                                                            .ids

      org_products = []
      if !organizations.empty?
        org_products += Product.joins(:organizations)
                               .where('organization_id in (?)', organizations)
                               .ids
      end

      sdg_products = org_products
      if !sdgs.empty?
        sdg_products += Product.joins(:sustainable_development_goals)
                               .where('sustainable_development_goal_id in (?)', sdgs)
                               .ids
      end

      use_case_bbs = get_bbs_from_use_cases(use_cases)
      workflow_bbs = get_bbs_from_workflows(workflows)

      bb_products = []
      bb_ids = filter_and_intersect_arrays([bbs, use_case_bbs, workflow_bbs])
      if !bb_ids.nil? && !bb_ids.empty?
        bb_products += Product.joins(:building_blocks)
                              .where('building_blocks.id in (?)', bb_ids)
                              .ids
      end

      product_ids = get_products_from_filters(products, origins, with_maturity_assessment, is_launchable, tags)
      [filter_and_intersect_arrays([sdg_products, bb_products, product_ids, project_product_ids]), filter_set]
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
          if attr[:est_hosting].present? && !attr[:est_hosting].nil?
            attr[:est_hosting] = attr[:est_hosting].to_i
          end
          if attr[:est_invested].present? && !attr[:est_invested].nil?
            attr[:est_invested] = attr[:est_invested].to_i
          end
          if policy(Product).permitted_attributes.include?(:aliases)
            valid_aliases = []
            if params[:other_names].present?
              valid_aliases = params[:other_names].reject(&:empty?)
            end
            attr[:aliases] = valid_aliases
          end
          if policy(Product).permitted_attributes.include?(:tags)
            valid_tags = []
            if params[:product_tags].present?
              valid_tags = params[:product_tags].reject(&:empty?).map(&:downcase)
            end
            attr[:tags] = valid_tags
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
