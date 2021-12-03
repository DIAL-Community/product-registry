class BuildingBlocksController < ApplicationController
  include FilterConcern
  include ApiFilterConcern

  acts_as_token_authentication_handler_for User, only: [:new, :create, :edit, :update, :destroy]

  before_action :set_building_block, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :duplicate]
  before_action :set_current_user, only: [:edit, :update, :destroy]

  def unique_search
    record = BuildingBlock.eager_load(:workflows, :building_block_descriptions,
                                      :product_building_blocks, :products)
                          .find_by(slug: params[:id])
    if record.nil?
      return render(json: {}, status: :not_found)
    end

    render(json: record.to_json(BuildingBlock.serialization_options
                                             .merge({
                                               item_path: request.original_url,
                                               include_relationships: true
                                             })))
  end

  def simple_search
    page_size = 20
    building_blocks = BuildingBlock

    current_page = 1
    if params[:page].present? && params[:page].to_i > 0
      current_page = params[:page].to_i
    end

    if params[:search].present?
      building_blocks = building_blocks.name_contains(params[:search])
    end

    results = {
      url: request.original_url,
      count: building_blocks.count,
      page_size: page_size
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if building_blocks.count > page_size * current_page
      query["page"] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = URI.decode(uri.to_s)
    end

    if current_page > 1
      query["page"] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = URI.decode(uri.to_s)
    end

    results['results'] = building_blocks.eager_load(:workflows, :building_block_descriptions,
                                              :product_building_blocks, :products)
                                        .paginate(page: current_page, per_page: page_size)
                                        .order(:slug)

    uri.fragment = uri.query = nil
    respond_to do |format|
      format.csv do
        render(csv: results['results'].to_csv, filename: 'csv-building-blocks')
      end
      format.json do
        render(json: results.to_json(BuildingBlock.serialization_options
                                                  .merge({
                                                    collection_path: uri.to_s,
                                                    include_relationships: true
                                                  })))
      end
    end
  end

  def complex_search
    page_size = 20
    building_blocks = BuildingBlock

    current_page = 1
    if params[:page].present? && params[:page].to_i > 0
      current_page = params[:page].to_i
    end

    if params[:search].present?
      name_bbs = building_blocks.name_contains(params[:search])
      desc_bbs = building_blocks.joins(:building_block_descriptions)
                                .where('LOWER(building_block_descriptions.description) like LOWER(?)',
                                       "%#{params[:search]}%")
      building_blocks = building_blocks.where(id: (name_bbs + desc_bbs).uniq)
    end

    sdg_use_case_slugs = []
    if valid_array_parameter(params[:sdgs])
      sdg_use_case_slugs = use_cases_from_sdg_slugs(params[:sdgs])
    end
    if sdg_use_case_slugs.nil? && valid_array_parameter(params[:sustainable_development_goals])
      sdg_use_case_slugs = use_cases_from_sdg_slugs(params[:sustainable_development_goals])
    end

    use_case_slugs = sdg_use_case_slugs
    if valid_array_parameter(params[:use_cases])
      if use_case_slugs.nil? || use_case_slugs.empty?
        use_case_slugs = params[:use_cases]
      else
        use_case_slugs &= params[:use_cases]
      end
    end
    use_case_workflow_slugs = workflows_from_use_case_slugs(use_case_slugs)

    workflow_slugs = use_case_workflow_slugs
    if valid_array_parameter(params[:workflows])
      if workflow_slugs.nil? || workflow_slugs.empty?
        workflow_slugs = params[:workflows]
      else
        workflow_slugs &= params[:workflows]
      end
    end
    workflow_building_block_slugs = building_blocks_from_workflow_slugs(workflow_slugs)

    building_block_slugs = workflow_building_block_slugs
    if valid_array_parameter(params[:building_blocks])
      if building_block_slugs.nil? || building_block_slugs.empty?
        building_block_slugs = params[:building_blocks]
      else
        building_block_slugs &= params[:building_blocks]
      end
    end

    building_block_product_slugs = []
    if valid_array_parameter(params[:products])
      building_block_product_slugs = building_blocks_from_product_slugs(params[:products])
    end

    if building_block_slugs.nil? || building_block_slugs.empty?
      building_block_slugs = building_block_product_slugs
    elsif !building_block_product_slugs.nil? && !building_block_product_slugs.empty?
      building_block_slugs &= building_block_product_slugs
    end

    building_block_slugs = building_block_slugs.reject { |x| x.nil? || x.empty? }
    building_blocks = building_blocks.where(slug: building_block_slugs) \
      unless building_block_slugs.nil? || building_block_slugs.empty?

    if params[:page_size].present?
      if params[:page_size].to_i > 0
        page_size = params[:page_size].to_i
      elsif params[:page_size].to_i < 0
        page_size = building_blocks.count
      end
    end

    results = {
      url: request.original_url,
      count: building_blocks.count,
      page_size: page_size
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if building_blocks.count > page_size * current_page
      query["page"] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = URI.decode(uri.to_s)
    end

    if current_page > 1
      query["page"] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = URI.decode(uri.to_s)
    end

    results['results'] = building_blocks.eager_load(:workflows, :building_block_descriptions,
                                              :product_building_blocks, :products)
                                        .paginate(page: current_page, per_page: page_size)
                                        .order(:slug)

    uri.fragment = uri.query = nil
    respond_to do |format|
      format.csv do
        render(csv: results['results'].to_csv, filename: 'csv-building-blocks')
      end
      format.json do
        render(json: results.to_json(BuildingBlock.serialization_options
                                                  .merge({
                                                    collection_path: uri.to_s,
                                                    include_relationships: true
                                                  })))
      end
    end
  end

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
      @building_blocks = @building_blocks.where(':tag = building_blocks.maturity', tag: 'MATURE')
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

  def export_data
    @building_blocks = BuildingBlock.where(id: filter_building_blocks).eager_load(:products, :workflows, :building_block_descriptions)
    authorize(@building_blocks, :view_allowed?)
    respond_to do |format|
      format.csv do
        render csv: @building_blocks, filename: 'exported-building-block'
      end
      format.json do
        render json: @building_blocks.to_json(BuildingBlock.serialization_options)
      end
    end
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
    @building_block.set_current_user(current_user)
    @bb_desc = BuildingBlockDescription.new
    @bb_desc.set_current_user(current_user)

    if params[:selected_products].present? &&  policy(@building_block).adding_mapping_allowed?
      params[:selected_products].keys.each do |product_id|
        new_prod_bb = ProductBuildingBlock.new
        new_prod_bb.product_id = product_id

        mapping_status = ProductBuildingBlock.mapping_status_types[:BETA]
        unless policy(@building_block).beta_only?
          mapping_status = ProductBuildingBlock.mapping_status_types[:VALIDATED]
        end
        new_prod_bb.mapping_status = mapping_status
        new_prod_bb.association_source = ProductBuildingBlock.RIGHT

        @building_block.product_building_blocks << new_prod_bb
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
      @building_block.set_image_changed(params[:logo].original_filename)
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
        if (building_block_params[:bb_desc])
          @bb_desc.building_block_id = @building_block.id
          @bb_desc.locale = I18n.locale
          @bb_desc.description = building_block_params[:bb_desc]
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

    if params[:selected_products].present? &&
       (policy(@building_block).removing_mapping_allowed? || policy(@building_block).adding_mapping_allowed?)

      existing_products = ProductBuildingBlock.where(building_block_id: @building_block.id)
                                              .pluck('product_id')
      ui_products = params[:selected_products].keys.map(&:to_i)

      if policy(@building_block).removing_mapping_allowed?
        removed_products = existing_products - ui_products
        logger.debug("Removing: #{removed_products} building block - products relationship.")

        removed_products.each do |product_id|
          @building_block.products.delete(product_id)
        end
      end

      if policy(@building_block).adding_mapping_allowed?
        added_products = ui_products - existing_products
        logger.debug("Adding: #{added_products} building block - products relationship.")

        added_products.each do |product_id|
          new_prod_bb = ProductBuildingBlock.new
          new_prod_bb.product_id = product_id

          mapping_status = ProductBuildingBlock.mapping_status_types[:BETA]
          unless policy(@building_block).beta_only?
            mapping_status = ProductBuildingBlock.mapping_status_types[:VALIDATED]
          end
          new_prod_bb.mapping_status = mapping_status
          new_prod_bb.association_source = ProductBuildingBlock.RIGHT

          @building_block.product_building_blocks << new_prod_bb
        end
      end
    end

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
      @building_block.set_image_changed(params[:logo].original_filename)
    end

    if building_block_params[:bb_desc].present?
      if @bb_desc.locale != I18n.locale.to_s
        @bb_desc = BuildingBlockDescription.new
      end
      @bb_desc.building_block_id = @building_block.id
      @bb_desc.locale = I18n.locale
      @bb_desc.description = building_block_params[:bb_desc]
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
        format.html { redirect_to(building_block_path(@building_block, locale: session[:locale]),
                                  flash: { notice: t('messages.model.updated', model: t('model.building-block').to_s.humanize) })}
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

  def bb_fs 
    @building_blocks = BuildingBlock.name_contains(params[:search])
                                      .order(:name)
    @bb_desc = [{name: 'Analytics and Business Intelligence', desc: 'Provides data-driven insights about business processes, performance and predictive modelling.'},
      {name: 'Artificial Intelligence', desc: 'AI capabilities packaged as reusable services to perform work, extract insights from data, or provide other business capabilities.'},
      {name: 'Client Case Management', desc: 'Registration of a client and the longitudinal tracking of services for the client, often across multiple service categories, providers and locations.'},
      {name: 'Collaboration Management', desc: 'Enables multiple users to simultaneously access, modify or contribute to a single activity, such as content creation, through a unified portal.'},
      {name: 'Consent Management', desc: 'Manages a set of policies allowing users to determine the info that will be accessible to specific potential info consumers, for which purpose, for how long and whether this info can be shared.<br/><br/>'},
      {name: 'Content Management', desc: 'Supports the creation, editing, publication and management of digital media and other information.'},
      {name: 'Data Collection', desc: 'Supports data collection from humans, sensors and other systems through digital interfaces.'},
      {name: 'Digital Registries', desc: 'Registries are centrally managed databases that uniquely identify persons, vendors, procedures, products and sites related to an organization or activity.'},
      {name: 'eLearning', desc: 'Supports facilitated or remote learning through digital interaction between educators and students.'},
      {name: 'eMarketplace', desc: 'Provides a digital marketing space where provider entities can electronically advertise & sell products & services to other entities (B2B) or end-customers (B2C).'},
      {name: 'Geographic Information Services (GIS)', desc: 'Provides functionality to identify, tag and analyze geographic locations of an object, such as a water source, building, mobile phone or medical commodity.'},
      {name: 'Identification and Authentication', desc: 'Enables unique identification and authentication of users, organizations and other entities.'},
      {name: 'Information Mediator', desc: 'Provides a gateway between external digital apps & ICT Building Blocks, ensuring implementation of standards, for integrating various ICT Building Blocks & apps.'},
      {name: 'Messaging', desc: 'Facilitates notifications, alerts and two-way communications between applications and communications services, including SMS, USSD, IVR, email and social media platforms.'},
      {name: 'Mobility Management', desc: 'Services to securely enable employees’ use and management of mobile devices and applications in a business context.'},
      {name: 'Payments', desc: 'Implements financial transactions (e.g., remittances, claims, purchases & payments, transactional info). Tracking costs utilities & audit trials.'},
      {name: 'Registration', desc: 'Records identifiers and general information about a person, place or entity, typically for the purpose of registration  in specific services or programmes and tracking of that entity over time.'},
      {name: 'Reporting and Dashboards', desc: 'Provides pre-packaged and custom presentations of data and summaries of an organization’s pre-defined key performance metrics, often in visual format.'},
      {name: 'Scheduling', desc: 'Provides an engine for setting up events based on regular intervals or specific combinations of status of several parameters in order to trigger specific tasks in an automated business process.'},
      {name: 'Security', desc: 'Allows ICT admins to centrally configure & manage user access permissions to network resources, services, databases, apps and devices. Enables secure info exchange between apps.'},
      {name: 'Shared Data Repositories', desc: 'Shared space to store data for a specified knowledge area that external applications use, often providing domain-specific functionality and data presentations.'},
      {name: 'Terminology', desc: 'Registry of definitions with defined standards, synonyms for a particular domain of knowledge (eg agriculture), used to facilitate semantic interoperability.'},
      {name: 'Workflow and Algorithm', desc: 'Optimize business processes by specifying rules that govern the sequence of activities executed, the type of info exchanged  to orchestrate the process flow from initiation to completion.'},
  ]
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
      @bb_desc ||= BuildingBlockDescription.where(building_block_id: @building_block, locale: I18n.default_locale).first
      if !@bb_desc
        @bb_desc = BuildingBlockDescription.new
      end
    end

    def set_current_user
      @building_block.set_current_user(current_user)
      @bb_desc.set_current_user(current_user)
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
