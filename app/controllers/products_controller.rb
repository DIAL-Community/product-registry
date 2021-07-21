class ProductsController < ApplicationController
  include ProductsHelper
  include FilterConcern
  include ApiFilterConcern

  acts_as_token_authentication_handler_for User, only: [:index, :new, :create, :edit, :update, :destroy]

  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :load_maturity, only: [:show, :new, :edit, :create, :update]
  before_action :set_current_user, only: [:edit, :update, :destroy]

  def unique_search
    record = Product.eager_load(:organizations,
                                  :products_origins, :origins,
                                  :sectors, :sectors,
                                  :product_sustainable_development_goals, :sustainable_development_goals,
                                  :product_building_blocks, :building_blocks)
                    .find_by(slug: params[:id])
    if record.nil?
      return render(json: {}, status: :not_found)
    end

    render(json: record.to_json(Product.serialization_options
                                       .merge({
                                         item_path: request.original_url,
                                         include_relationships: true
                                       })))
  end

  def simple_search
    default_page_size = 20
    products = Product

    current_page = 1
    if params[:page].present? && params[:page].to_i > 0
      current_page = params[:page].to_i
    end

    if params[:search].present?
      products = products.name_contains(params[:search])
    end

    if params[:origins].present?
      origins = params[:origins].reject { |x| x.nil? || x.empty? }
      products = products.joins(:origins)
                         .where(origins: { slug: origins }) \
        unless origins.empty?
    end

    products = products.paginate(page: current_page, per_page: default_page_size)

    results = {
      url: request.original_url,
      count: products.count,
      page_size: default_page_size
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if products.count > default_page_size * current_page
      query["page"] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = URI.decode(uri.to_s)
    end

    if current_page > 1
      query["page"] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = URI.decode(uri.to_s)
    end

    results['results'] = products.eager_load(:organizations,
                                             :products_origins, :origins,
                                             :sectors, :sectors,
                                             :product_sustainable_development_goals, :sustainable_development_goals,
                                             :product_building_blocks, :building_blocks)
                                 .paginate(page: current_page, per_page: default_page_size)
                                 .order(:slug)

    uri.fragment = uri.query = nil
    render(json: results.to_json(Product.serialization_options
                                        .merge({
                                          collection_path: uri.to_s,
                                          include_relationships: true
                                        })))
  end

  def complex_search
    default_page_size = 20
    products = Product

    current_page = 1
    if params[:page].present? && params[:page].to_i > 0
      current_page = params[:page].to_i
    end

    if params[:search].present?
      products = products.name_contains(params[:search])
    end

    if params[:origins].present?
      origins = params[:origins].reject { |x| x.nil? || x.empty? }
      products = products.joins(:origins)
                         .where(origins: { slug: origins }) \
        unless origins.empty?
    end

    sdg_use_case_slugs = nil
    if valid_array_parameter(params[:sdgs])
      sdg_use_case_slugs = use_cases_from_sdg_slugs(params[:sdgs])
    end
    if sdg_use_case_slugs.nil? && valid_array_parameter(params[:sustainable_development_goals])
      sdg_use_case_slugs = use_cases_from_sdg_slugs(params[:sustainable_development_goals])
    end

    use_case_slugs = nil
    if valid_array_parameter(params[:use_cases])
      use_case_slugs = params[:use_cases] if sdg_use_case_slugs.nil?
      use_case_slugs = sdg_use_case_slugs & params[:use_cases] unless sdg_use_case_slugs.nil?
    else
      use_case_slugs = sdg_use_case_slugs
    end
    use_case_workflow_slugs = workflows_from_use_case_slugs(use_case_slugs) \
      unless use_case_slugs.nil?

    workflow_slugs = nil
    if valid_array_parameter(params[:workflows])
      workflow_slugs = params[:workflows] if use_case_workflow_slugs.nil?
      workflow_slugs = use_case_workflow_slugs & params[:workflows] unless use_case_workflow_slugs.nil?
    else
      workflow_slugs = use_case_workflow_slugs
    end

    workflow_building_block_slugs = building_blocks_from_workflow_slugs(workflow_slugs) \
      unless workflow_slugs.nil?

    building_block_slugs = nil
    if valid_array_parameter(params[:building_blocks])
      building_block_slugs = params[:building_blocks] if workflow_building_block_slugs.nil?
      building_block_slugs = workflow_building_block_slugs & params[:building_blocks] \
        unless workflow_building_block_slugs.nil?
    else
      building_block_slugs = workflow_building_block_slugs
    end

    building_block_product_slugs = products_from_building_block_slugs(building_block_slugs) \
      unless building_block_slugs.nil?

    product_slugs = nil
    if valid_array_parameter(params[:products])
      product_slugs = params[:products] if building_block_product_slugs.nil?
      product_slugs = building_block_product_slugs & params[:products] \
        unless building_block_product_slugs.nil?
    else
      product_slugs = building_block_product_slugs
    end

    product_slugs = product_slugs.reject { |x| x.nil? || x.empty? }
    products = products.where(slug: product_slugs) unless product_slugs.nil?

    results = {
      url: request.original_url,
      count: products.count,
      page_size: default_page_size
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if products.count > default_page_size * current_page
      query["page"] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = URI.decode(uri.to_s)
    end

    if current_page > 1
      query["page"] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = URI.decode(uri.to_s)
    end

    results['results'] = products.eager_load(:organizations,
                                             :products_origins, :origins,
                                             :sectors, :sectors,
                                             :product_sustainable_development_goals, :sustainable_development_goals,
                                             :product_building_blocks, :building_blocks)
                                 .paginate(page: current_page, per_page: default_page_size)
                                 .order(:slug)

    uri.fragment = uri.query = nil
    render(json: results.to_json(Product.serialization_options
                                        .merge({
                                          collection_path: uri.to_s,
                                          include_relationships: true
                                        })))
  end

  def map
    @products = Product.order(:slug).eager_load(:references, :include_relationships, :interop_relationships)
    @product_relationships = ProductProductRelationship.order(:id).eager_load(:from_product, :to_product)
    render(layout: 'layouts/raw')
  end

  def favorite_product
    set_product
    if current_user.nil? || @product.nil?
      return respond_to { |format| format.json { render json: {}, status: :unauthorized } }
    end

    favoriting_user = current_user
    favoriting_user.saved_products.push(@product.id)

    respond_to do |format|
      if favoriting_user.save!
        format.json { render :show, status: :ok }
      else
        format.json { render :show, status: :unprocessable_entity }
      end
    end
  end

  def unfavorite_product
    set_product
    if current_user.nil? || @product.nil?
      return respond_to { |format| format.json { render json: {}, status: :unauthorized } }
    end

    favoriting_user = current_user
    favoriting_user.saved_products.delete(@product.id)

    respond_to do |format|
      if favoriting_user.save!
        format.json { render :show, status: :ok }
      else
        format.json { render :show, status: :unprocessable_entity }
      end
    end
  end

  # GET /products
  # GET /products.json
  def index
    if !session[:org].nil?
      # Check settings
      view_setting_slug = session[:org].downcase+'_default_view'
      default_view = Setting.where(slug: view_setting_slug).first
      if !default_view.nil?
        case default_view.value
        when 'custom'
          session[:portal] = PortalView.where(slug: session[:org].downcase).first
          if !session[:portal].nil?
            redirect_to about_path
          end
        when 'map'
          redirect_to map_path
        when 'wizard'
          redirect_to wizard_path
        end
      end
    end

    if params[:without_paging]
      @products = Product.name_contains(params[:search])
                         .order(Product.arel_table['name'].lower.asc)
      authorize(@products, :view_allowed?)
      return
    end

    # :filtered_time will be updated every time we add or remove a filter.
    if session[:filtered_time].to_s.downcase != session[:product_filtered_time].to_s.downcase
      # :product_filtered_time is not updated after the filter is updated:
      # - rebuild the product id cache
      logger.info('Filter updated. Rebuilding cached product id list.')

      product_ids = filter_products
      session[:product_filtered_ids] = product_ids
      session[:product_filtered] = true
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
                               .where("LOWER(description) like LOWER(?)", "%#{params[:search]}%")
      @products = @products.where(id: (name_products + desc_products).uniq)
    end

    @products = @products.eager_load(:includes, :interoperates_with, :origins, :organizations)
                         .paginate(page: current_page, per_page: 20)
                         .order(:name)

    authorize(@products, :view_allowed?)
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

    authorize(Product, :view_allowed?)
    render(json: product_count.count)
  end

  def export_data
    @products = Product.where(id: filter_products).eager_load(:organizations, :origins, :building_blocks, :sustainable_development_goals)
    authorize(@products, :view_allowed?)
    respond_to do |format|
      format.csv do
        render csv: @products, filename: 'exported-product'
      end
      format.json do
        render json: @products.to_json(Product.serialization_options)
      end
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    authorize(@product, :view_allowed?)
    # All of this data will be passed to the launch partial and used by javascript
    @jenkins_url = Rails.application.secrets.jenkins_url
    @jenkins_user = Rails.application.secrets.jenkins_user
    @jenkins_password = Rails.application.secrets.jenkins_password

    record_user_event(UserEvent.event_types[:product_view])

    # Right now, we are using the legacy rubric. Eventually we will change this to use
    # the default rubric - just use the 'else' part
    maturity_rubric = MaturityRubric.find_by(slug: 'legacy_rubric')
    if !maturity_rubric.nil?
      @maturity_scores = calculate_maturity_scores(@product.id, maturity_rubric.id)[:rubric_scores].first
    else
      @maturity_scores = calculate_maturity_scores(@product.id, nil)[:rubric_scores].first
    end
    if !@maturity_scores.nil?
      @maturity_scores = @maturity_scores[:category_scores]
    end
  end

  # GET /products/new
  def new
    authorize(Product, :create_allowed?)
    @product = Product.new
    @product_description = ProductDescription.new
  end

  # GET /products/1/edit
  def edit
    authorize(@product, :mod_allowed?)
  end

  # POST /products
  # POST /products.json
  def create
    authorize(Product, :create_allowed?)
    @product = Product.new(product_params)
    @product.set_current_user(current_user)
    @product_description = ProductDescription.new
    @product_description.set_current_user(current_user)

    if params[:selected_projects].present?
      params[:selected_projects].keys.each do |project_id|
        project = Project.find(project_id)
        @product.projects.push(project) unless project.nil?
      end
    end

    if params[:selected_organizations].present?
      params[:selected_organizations].keys.each do |organization_id|
        organization = Organization.find(organization_id)

        next if organization.nil?

        organization_product = OrganizationsProduct.new
        organization_product.organization = organization
        organization_product.product = @product
        organization_product.association_source = OrganizationsProduct.RIGHT

        @product.organizations_products.push(organization_product)
      end
    end

    if params[:selected_sectors].present?
      params[:selected_sectors].keys.each do |sector_id|
        new_prod_sector = ProductSector.new
        new_prod_sector.sector_id = sector_id

        mapping_status = ProductSector.mapping_status_types[:BETA]
        unless policy(@product).beta_only?
          mapping_status = ProductSector.mapping_status_types[:VALIDATED]
        end
        new_prod_sector.mapping_status = mapping_status

        @product.product_sectors << new_prod_sector
      end
    end

    if params[:selected_interoperable_products].present?
      params[:selected_interoperable_products].keys.each do |product_id|
        to_product = Product.find(product_id)

        next if to_product.nil?

        interoperable_product = ProductProductRelationship.new
        interoperable_product.relationship_type = ProductProductRelationship.relationship_types[:interoperates_with]
        interoperable_product.to_product = to_product
        interoperable_product.from_product = @product

        @product.interop_relationships.push(interoperable_product)
      end
    end

    if params[:selected_included_products].present?
      params[:selected_included_products].keys.each do |product_id|
        to_product = Product.find(product_id)

        next if to_product.nil?

        contains_product = ProductProductRelationship.new
        contains_product.relationship_type = ProductProductRelationship.relationship_types[:contains]
        contains_product.to_product = to_product
        contains_product.from_product = @product

        @product.include_relationships << contains_product
      end
    end

    if params[:selected_building_blocks].present? && policy(@product).adding_mapping_allowed?
      params[:selected_building_blocks].keys.each do |building_block_id|
        new_prod_bb = ProductBuildingBlock.new
        new_prod_bb.building_block_id = building_block_id

        mapping_status = ProductSustainableDevelopmentGoal.mapping_status_types[params[:sdg_mapping]]
        mapping_status ||= ProductSustainableDevelopmentGoal.mapping_status_types[:BETA]
        !policy(@product).beta_only? &&
          params[:sdg_mapping] == ProductSustainableDevelopmentGoal.mapping_status_types[:VALIDATED] &&
          mapping_status = ProductSustainableDevelopmentGoal.mapping_status_types[:VALIDATED]
        new_prod_bb.mapping_status = mapping_status

        @product.product_building_blocks << new_prod_bb
      end
    end

    if params[:selected_sustainable_development_goals].present?
      params[:selected_sustainable_development_goals].keys.each do |sustainable_development_goal_id|
        new_prod_sdg = ProductSustainableDevelopmentGoal.new
        new_prod_sdg.sustainable_development_goal_id = sustainable_development_goal_id

        mapping_status = ProductSustainableDevelopmentGoal.mapping_status_types[params[:sdg_mapping]]
        mapping_status ||= ProductSustainableDevelopmentGoal.mapping_status_types[:BETA]
        !policy(@product).beta_only? &&
          params[:sdg_mapping] == ProductSustainableDevelopmentGoal.mapping_status_types[:VALIDATED] &&
          mapping_status = ProductSustainableDevelopmentGoal.mapping_status_types[:VALIDATED]
        new_prod_sdg.mapping_status = mapping_status

        @product.product_sustainable_development_goals << new_prod_sdg
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

    # Create a Discourse topic for this product
    # topic_id = create_discourse_topic(@product, 'Products')

    respond_to do |format|
      if !@product.errors.any? && @product.save!

        if product_params[:product_description].present?
          @product_description.product_id = @product.id
          @product_description.locale = I18n.locale
          @product_description.description = product_params[:product_description]
          @product_description.save
        end

        format.html do
          redirect_to @product,
                      flash: { notice: t('messages.model.created', model: t('model.product').to_s.humanize) }
        end
        format.json { render :show, status: :created, location: @product }
      else
        logger.error("Create returning errors: #{@product.errors}.")

        error_message = ""
        @product.errors.each do |attr, err|
          error_message = err
        end
        format.html { redirect_to new_product_url, flash: { error: error_message } }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    authorize(@product, :mod_allowed?)

    projects = Set.new
    if params[:selected_projects].present?
      params[:selected_projects].keys.each do |project_id|
        project = Project.find(project_id)
        projects.add(project) unless project.nil?
      end
    end
    @product.projects = projects.to_a

    if params[:selected_organizations].present?
      existing_orgs = OrganizationsProduct.where(product_id: @product.id)
                                          .pluck('organization_id')
      ui_orgs = params[:selected_organizations].keys.map(&:to_i)

      removed_orgs = existing_orgs - ui_orgs
      logger.debug("Removing: #{removed_orgs} product - organizations relationship.")

      removed_orgs.each do |organization_id|
        @product.organizations.delete(organization_id)
      end

      added_orgs = ui_orgs - existing_orgs
      logger.debug("Adding: #{added_orgs} product - organizations relationship.")

      added_orgs.each do |organization_id|
        organization = Organization.find(organization_id)

        next if organization.nil?

        organization_product = OrganizationsProduct.new
        organization_product.organization = organization
        organization_product.product = @product
        organization_product.association_source = OrganizationsProduct.RIGHT

        @product.organizations_products << organization_product
      end
    end

    if params[:selected_sectors].present? &&
       (policy(@product).removing_mapping_allowed? || policy(@product).adding_mapping_allowed?)

      existing_sectors = ProductSector.where(product_id: @product.id)
                                      .pluck('sector_id')
      ui_sectors = params[:selected_sectors].keys.map(&:to_i)

      if policy(@product).removing_mapping_allowed?
        removed_sectors = existing_sectors - ui_sectors
        logger.debug("Removing: #{removed_sectors} product - sectors relationship.")

        removed_sectors.each do |sector_id|
          @product.sectors.delete(sector_id)
        end
      end

      if policy(@product).adding_mapping_allowed?
        added_sectors = ui_sectors - existing_sectors
        logger.debug("Adding: #{added_sectors} product - sectors relationship.")

        added_sectors.each do |sector_id|
          new_prod_sector = ProductSector.new
          new_prod_sector.sector_id = sector_id

          mapping_status = ProductSector.mapping_status_types[:BETA]
          unless policy(@product).beta_only?
            mapping_status = ProductSector.mapping_status_types[:VALIDATED]
          end
          new_prod_sector.mapping_status = mapping_status

          @product.product_sectors << new_prod_sector
        end
      end
    end

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

    if params[:selected_building_blocks].present? &&
       (policy(@product).removing_mapping_allowed? || policy(@product).adding_mapping_allowed?)

      existing_bbs = ProductBuildingBlock.where(product_id: @product.id)
                                         .pluck('building_block_id')
      ui_bbs = params[:selected_building_blocks].keys.map(&:to_i)

      if policy(@product).removing_mapping_allowed?
        removed_bbs = existing_bbs - ui_bbs
        logger.debug("Removing: #{removed_bbs} product - bbs relationship.")

        removed_bbs.each do |bb_id|
          @product.building_blocks.delete(bb_id)
        end
      end

      if policy(@product).adding_mapping_allowed?
        added_bbs = ui_bbs - existing_bbs
        logger.debug("Adding: #{added_bbs} product - bbs relationship.")

        added_bbs.each do |bb_id|
          new_prod_bb = ProductBuildingBlock.new
          new_prod_bb.building_block_id = bb_id

          mapping_status = ProductSustainableDevelopmentGoal.mapping_status_types[params[:sdg_mapping]]
          mapping_status ||= ProductSustainableDevelopmentGoal.mapping_status_types[:BETA]
          !policy(@product).beta_only? &&
            params[:sdg_mapping] == ProductSustainableDevelopmentGoal.mapping_status_types[:VALIDATED] &&
            mapping_status = ProductSustainableDevelopmentGoal.mapping_status_types[:VALIDATED]

          new_prod_bb.mapping_status = mapping_status

          @product.product_building_blocks << new_prod_bb
        end
      end
    end

    if params[:selected_sustainable_development_goals].present? &&
       (policy(@product).removing_mapping_allowed? || policy(@product).adding_mapping_allowed?)

      existing_sdgs = ProductSustainableDevelopmentGoal.where(product_id: @product.id)
                                                       .pluck('sustainable_development_goal_id')
      ui_sdgs = params[:selected_sustainable_development_goals].keys
                                                               .map(&:to_i)

      if policy(@product).removing_mapping_allowed?
        removed_sdgs = existing_sdgs - ui_sdgs
        logger.debug("Removing: #{removed_sdgs} product - sdgs relationship.")

        removed_sdgs.each do |sdg_id|
          @product.sustainable_development_goals.delete(sdg_id)
        end
      end

      if policy(@product).adding_mapping_allowed?
        added_sdgs = ui_sdgs - existing_sdgs
        logger.debug("Adding: #{added_sdgs} product - sdgs relationship.")

        added_sdgs.each do |sdg_id|
          new_prod_sdg = ProductSustainableDevelopmentGoal.new
          new_prod_sdg.sustainable_development_goal_id = sdg_id

          mapping_status = ProductSustainableDevelopmentGoal.mapping_status_types[params[:sdg_mapping]]
          mapping_status ||= ProductSustainableDevelopmentGoal.mapping_status_types[:BETA]
          !policy(@product).beta_only? &&
            params[:sdg_mapping] == ProductSustainableDevelopmentGoal.mapping_status_types[:VALIDATED] &&
            mapping_status = ProductSustainableDevelopmentGoal.mapping_status_types[:VALIDATED]
          new_prod_sdg.mapping_status = mapping_status

          @product.product_sustainable_development_goals << new_prod_sdg
        end
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
      @product_description.description = product_params[:product_description]
      @product_description.save
    end

    respond_to do |format|
      if @product.errors.none? && @product.update!(product_params)
        format.html do
          redirect_to @product,
                      flash: { notice: t('messages.model.updated', model: t('model.product').to_s.humanize) }
        end
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
    authorize(@product, :mod_allowed?)
    @product.destroy
    respond_to do |format|
      format.html do
        redirect_to products_url,
                    flash: { notice: t('messages.model.deleted', model: t('model.product').to_s.humanize) }
      end
      format.json { head :no_content }
    end
  end

  def duplicates
    @products = []
    if params[:current].present?
      current_slug = slug_em(params[:current])
      original_slug = slug_em(params[:original])
      if current_slug != original_slug
        @products = Product.where(slug: current_slug)
      end

      if @products.empty?
        @products = Product.where(':other_name = ANY(aliases)', other_name: params[:current])
      end
    end
    authorize(Product, :view_allowed?)
    render(json: @products, :only => [:name])
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

      org_list = product.organizations.order(:name).map do |org|
        org_prod = OrganizationsProduct.where(product_id: product, organization_id: org).first
        { :name => org.name, :website => 'https://'+org.website.to_s, :org_type => org_prod.org_type }
      end

      # Get data from publicgoods_data attribute
      publicgoods_name = product.publicgoods_data['name']
      publicgoods_licenseURL = product.publicgoods_data['licenseURL']
      publicgoods_aliases = product.publicgoods_data['aliases']
      publicgoods_stage = product.publicgoods_data['stage']

      description = ProductDescription.where(product_id: product, locale: I18n.locale).first

      if description.nil? 
        product_desc = ""
      else
        product_desc = description.description
      end

      repositoryURL=""
      if !product.repository.nil?
        repositoryURL = product.repository
      end

      { :name => product.name, :publicgoods_name => publicgoods_name, :aliases => publicgoods_aliases.as_json, :stage => publicgoods_stage, :description => product_desc, :website => 'https://'+product.website.to_s, :license => [{:spdx => product.license, :licenseURL => publicgoods_licenseURL}], :SDGs => sdg_list.as_json, :sectors => sector_list.as_json, :type => [ "software" ], :repositoryURL => repositoryURL, :organizations => org_list.as_json }
    end

    curr_products.each do |prod|
      if !prod.nil?
        @products.push(prod)
      end
    end

    render json: @products
  end

  private

  def record_user_event(event_type)
    user_event = UserEvent.new
    user_event.identifier = session[:default_identifier]
    user_event.event_type = event_type
    user_event.event_datetime = Time.now

    unless current_user.nil?
      user_event.email = current_user.email
    end

    unless @product.nil?
      user_event.extended_data = { slug: @product.slug, name: @product.name }
    end

    if user_event.save!
      logger.info("User event '#{event_type}' for #{user_event.identifier} saved.")
    end
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find_by(slug: params[:id])
      if @product.nil? && params[:id].scan(/\D/).empty?
        @product = Product.find_by(id: params[:id])
      end
      @product_description = ProductDescription.where(product_id: @product, locale: I18n.locale)
                                               .first
      @product_description ||= ProductDescription.where(product_id: @product, locale: I18n.default_locale)
                                               .first
      if @product_description.nil?
        @product_description = ProductDescription.new
      end
      @child_products = Product.where(parent_product_id: @product)
      if !@child_products.empty?
        @child_descriptions = ProductDescription.where(product_id: @child_products)
      end

      @owner = User.where("?=ANY(user_products)", @product.id)
    end

    def set_current_user
      @product.set_current_user(current_user)
      @product_description.set_current_user(current_user)
    end

    def load_maturity
      @osc_maturity = YAML.load_file("config/maturity_osc.yml")
      @digisquare_maturity = YAML.load_file("config/maturity_digisquare.yml")
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      permitted_attributes = policy(Product).permitted_attributes
      unless @product.nil?
        permitted_attributes = policy(@product).permitted_attributes
      end

      params
        .require(:product)
        .permit(permitted_attributes)
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
          if permitted_attributes.include?(:aliases)
            valid_aliases = []
            if params[:other_names].present?
              valid_aliases = params[:other_names].reject(&:empty?)
            end
            attr[:aliases] = valid_aliases
          end
          if permitted_attributes.include?(:tags)
            valid_tags = []
            if params[:product_tags].present?
              valid_tags = params[:product_tags].reject(&:empty?).map(&:downcase)
            end
            attr[:tags] = valid_tags
          end
          if params[:reslug].present? && permitted_attributes.include?(:slug)
            attr[:slug] = slug_em(attr[:name])
            if params[:duplicate].present?
              first_duplicate = Product.slug_starts_with(attr[:slug]).order(slug: :desc).first
              attr[:slug] = attr[:slug] + generate_offset(first_duplicate).to_s
            end
          end
        end
    end
end
