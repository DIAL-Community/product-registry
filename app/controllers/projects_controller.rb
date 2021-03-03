class ProjectsController < ApplicationController
  include FilterConcern
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def unique_search
    record = Project.eager_load(:countries, :organizations, :products, :origin,
                                :sustainable_development_goals, :sectors)
                    .find_by(slug: params[:id])
    if record.nil?
      return render(json: {}, status: :not_found)
    end

    render(json: record.to_json(Project.serialization_options
                                       .merge({
                                         item_path: request.original_url,
                                         include_relationships: true
                                       })))
  end

  def simple_search
    default_page_size = 20
    projects = Project

    current_page = 1
    if params[:page].present? && params[:page].to_i > 0
      current_page = params[:page].to_i
    end

    if params[:search].present?
      projects = projects.name_contains(params[:search])
    end

    if params[:origins].present?
      origins = params[:origins].reject { |x| x.nil? || x.empty? }
      projects = projects.where(origin: Origin.where(slug: origins)) \
        unless origins.empty?
    end

    results = {
      url: request.original_url,
      count: projects.count,
      page_size: default_page_size
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if projects.count > default_page_size * current_page
      query["page"] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = URI.decode(uri.to_s)
    end

    if current_page > 1
      query["page"] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = URI.decode(uri.to_s)
    end

    results['results'] = projects.eager_load(:countries, :organizations, :origin, :products,
                                             :sustainable_development_goals, :sectors)
                                 .paginate(page: current_page, per_page: default_page_size)
                                 .order(:slug)

    uri.fragment = uri.query = nil
    render(json: results.to_json(Project.serialization_options
                                        .merge({
                                          collection_path: uri.to_s,
                                          include_relationships: true
                                        })))
  end

  def complex_search
    default_page_size = 20
    projects = Project

    current_page = 1
    if params[:page].present? && params[:page].to_i > 0
      current_page = params[:page].to_i
    end

    if params[:search].present?
      projects = projects.name_contains(params[:search])
    end

    if params[:origins].present?
      origins = params[:origins].reject { |x| x.nil? || x.empty? }
      projects = projects.where(origin: Origin.where(slug: origins)) \
        unless origins.empty?
    end

    if params[:sectors].present?
      sectors = params[:sectors].reject { |x| x.nil? || x.empty? }
      projects = projects.joins(:sectors)
                         .where('sectors.slug in (?)', sectors) \
        unless sectors.empty?
    end

    if params[:products].present?
      products = params[:products].reject { |x| x.nil? || x.empty? }
      projects = projects.joins(:products)
                         .where('products.slug in (?)', products) \
        unless products.empty?
    end

    if params[:organizations].present?
      organizations = params[:organizations].reject { |x| x.nil? || x.empty? }
      projects = projects.joins(:organizations)
                         .where('organizations.slug in (?)', organizations) \
        unless organizations.empty?
    end

    if params[:countries].present?
      countries = params[:countries].reject { |x| x.nil? || x.empty? }
      projects = projects.joins(:countries)
                         .where('countries.slug in (?)', countries) \
        unless countries.empty?
    end

    results = {
      url: request.original_url,
      count: projects.count,
      page_size: default_page_size
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if projects.count > default_page_size * current_page
      query["page"] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = URI.decode(uri.to_s)
    end

    if current_page > 1
      query["page"] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = URI.decode(uri.to_s)
    end

    results['results'] = projects.eager_load(:countries, :organizations, :products, :origin,
                                             :sustainable_development_goals, :sectors)
                                 .paginate(page: current_page, per_page: default_page_size)
                                 .order(:slug)

    uri.fragment = uri.query = nil
    render(json: results.to_json(Project.serialization_options
                                        .merge({
                                          collection_path: uri.to_s,
                                          include_relationships: true
                                        })))
  end

  def favorite_project
    set_project
    if current_user.nil? || @project.nil?
      return respond_to { |format| format.json { render json: {}, status: :unauthorized } }
    end

    favoriting_user = current_user
    favoriting_user.saved_projects.push(@project.id)

    respond_to do |format|
      if favoriting_user.save!
        format.json { render :show, status: :ok }
      else
        format.json { render :show, status: :unprocessable_entity }
      end
    end
  end

  def unfavorite_project
    set_project
    if current_user.nil? || @project.nil?
      return respond_to { |format| format.json { render json: {}, status: :unauthorized } }
    end

    favoriting_user = current_user
    favoriting_user.saved_projects.delete(@project.id)

    respond_to do |format|
      if favoriting_user.save!
        format.json { render :show, status: :ok }
      else
        format.json { render :show, status: :unprocessable_entity }
      end
    end
  end

  def map_projects_osm
  end

  def index
    if params[:without_paging]
      @projects = Project.name_contains(params[:search])
                         .eager_load(:countries)
                         .order(:name)

      if params[:origin]
        @projects = @projects.where('origin_id=(select id from origins where slug like ?)', params[:origin])
      end
      return
    end

    # :filtered_time will be updated every time we add or remove a filter.
    if session[:filtered_time].to_s.downcase != session[:project_filtered_time].to_s.downcase
      # :project_filtered_time is not updated after the filter is updated:
      # - rebuild the project id cache
      logger.info('Filter updated. Rebuilding cached project id list.')

      project_ids = filter_projects
      session[:project_filtered_ids] = project_ids
      session[:project_filtered] = true
      session[:project_filtered_time] = session[:filtered_time]
    end

    # Current page information will be stored in the main page div.
    current_page = params[:page] || 1

    @projects = Project.order(:slug)
    if session[:project_filtered].to_s.downcase == 'true'
      @projects = @projects.where(id: session[:project_filtered_ids])
    end

    @projects = @projects.eager_load(:organizations, :products, :locations, :origin)
                         .paginate(page: current_page, per_page: 20)

    params[:search].present? && @projects = @projects.name_contains(params[:search])
    authorize @projects, :view_allowed?
  end

  def count
    # :filtered_time will be updated every time we add or remove a filter.
    if session[:filtered_time].to_s.downcase != session[:project_filtered_time].to_s.downcase
      # :project_filtered_time is not updated after the filter is updated:
      # - rebuild the project id cache
      logger.info('Filter updated. Rebuilding cached project id list.')

      project_ids, filter_set = filter_projects
      session[:project_filtered_ids] = project_ids
      session[:project_filtered] = filter_set
      session[:project_filtered_time] = session[:filtered_time]
    end

    authorize @projects, :view_allowed?
    render json: @projects.count
  end

  def export_data
    @projects = Project.where(id: filter_projects).eager_load(:organizations, :products)
    authorize(@projects, :view_allowed?)
    respond_to do |format|
      format.csv do
        render csv: @projects, filename: 'exported-project'
      end
      format.json do
        render json: @projects.to_json(Project.serialization_options)
      end
    end
  end

  def show
    authorize @project, :view_allowed?
  end

  def new
    authorize Project, :mod_allowed?
    @project = Project.new

    # Defaulting to manually entered, but allow user to change it.
    @project.origin = Origin.find_by(slug: 'manually_entered')

    unless current_user.nil?
      current_user.products.each do |product|
        @project.products.push(product)
      end

      organization = Organization.find_by(id: current_user.organization_id)
      unless organization.nil?
        @project.organizations.push(organization)
      end
    end

    @project_description = ProjectDescription.new
  end

  def create
    authorize Project, :mod_allowed?
    @project = Project.new(project_params)

    if params[:selected_organizations].present?
      params[:selected_organizations].keys.each do |organization_id|
        organization = Organization.find(organization_id)

        next if organization.nil?

        unless policy(organization).adding_mapping_allowed?
          # Skip if we already assign value to the session
          next if session[:project_elevated_role].to_s.downcase == 'true'

          session[:project_elevated_role] = true
          next
        end

        @project.organizations.push(organization)
      end
    end

    if params[:selected_countries].present?
      params[:selected_countries].keys.each do |country_id|
        country = Country.find(country_id)
        @project.countries.push(country) unless country.nil?
      end
    end

    if params[:selected_products].present?
      params[:selected_products].keys.each do |product_id|
        product = Product.find(product_id)

        next if product.nil?

        unless policy(product).adding_mapping_allowed?
          # Skip if we already assign value to the session
          next if session[:project_elevated_role].to_s.downcase == 'true'

          session[:project_elevated_role] = true
          next
        end

        @project.products.push(product)
      end
    end

    respond_to do |format|
      if @project.save!

        if project_params[:project_description].present?
          @project_description = ProjectDescription.new
          @project_description.project_id = @project.id
          @project_description.locale = I18n.locale
          @project_description.description = project_params[:project_description]
          @project_description.save
        end

        format.html do
          redirect_to @project,
                      flash: { notice: t('messages.model.created', model: t('model.project').to_s.humanize) }
        end
        format.json { render :show, status: :created, project: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    authorize @project, :mod_allowed?
  end

  def update
    authorize(@project, :mod_allowed?)
    if params[:selected_organizations].present?
      existing_org_ids = @project.organizations.map(&:id)
      ui_org_ids = params[:selected_organizations].keys
                                                  .map(&:to_i)

      removed_org_ids = existing_org_ids - ui_org_ids
      logger.debug("Removing: [#{removed_org_ids}] organization ids from project.")

      removed_org_ids.each do |removed_org_id|
        organization = Organization.find(removed_org_id)

        next if organization.nil?

        unless policy(organization).removing_mapping_allowed?
          # Skip if we already assign value to the session
          next if session[:project_elevated_role].to_s.downcase == 'true'

          session[:project_elevated_role] = true
          next
        end

        @project.organizations.delete(removed_org_id)
      end

      added_org_ids = ui_org_ids - existing_org_ids
      logger.debug("Adding: [#{added_org_ids}] organization ids to project.")

      added_org_ids.each do |added_org_id|
        organization = Organization.find(added_org_id)

        next if organization.nil?

        unless policy(organization).adding_mapping_allowed?
          # Skip if we already assign value to the session
          next if session[:project_elevated_role].to_s.downcase == 'true'

          session[:project_elevated_role] = true
          next
        end

        @project.organizations.push(organization)
      end
    end

    if params[:selected_countries].present?
      countries = Set.new
      params[:selected_countries].keys.each do |country_id|
        country = Country.find(country_id)
        countries.add(country) unless country.nil?
      end
      @project.countries = countries.to_a
    end

    if params[:selected_products].present?
      existing_product_ids = @project.products.map(&:id)
      ui_product_ids = params[:selected_products].keys
                                                 .map(&:to_i)

      removed_product_ids = existing_product_ids - ui_product_ids
      logger.debug("Removing: [#{removed_product_ids}] product ids from project.")

      removed_product_ids.each do |removed_product_id|
        product = Product.find(removed_product_id)

        next if product.nil?

        unless policy(product).removing_mapping_allowed?
          # Skip if we already assign value to the session
          next if session[:project_elevated_role].to_s.downcase == 'true'

          session[:project_elevated_role] = true
          next
        end

        @project.products.delete(removed_product_id)
      end

      added_product_ids = ui_product_ids - existing_product_ids
      logger.debug("Adding: [#{added_product_ids}] product ids to project.")

      added_product_ids.each do |added_product_id|
        product = Product.find(added_product_id)

        next if product.nil?

        unless policy(product).adding_mapping_allowed?
          # Skip if we already assign value to the session
          next if session[:project_elevated_role].to_s.downcase == 'true'

          session[:project_elevated_role] = true
          next
        end

        @project.products.push(product)
      end
    end

    if project_params[:project_description].present?
      @project_description.project_id = @project.id
      @project_description.locale = I18n.locale
      @project_description.description = project_params[:project_description]
      @project_description.save
    end

    respond_to do |format|
      if @project.update!(project_params)
        format.html do
          redirect_to @project,
                      flash: { notice: t('messages.model.updated', model: t('model.project').to_s.humanize) }
        end
        format.json { render :show, status: :ok, project: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize @project, :mod_allowed?
    @project.destroy
    respond_to do |format|
      format.html do
        redirect_to projects_url,
                    flash: { notice: t('messages.model.deleted', model: t('model.project').to_s.humanize) }
      end
      format.json { head :no_content }
    end
  end

  def duplicates
    @projects = []
    if params[:current].present?
      current_slug = slug_em(params[:current])
      original_slug = slug_em(params[:original])
      if current_slug != original_slug
        @projects = Project.where(slug: current_slug).to_a
      end
    end
    authorize Project, :view_allowed?
    render json: @projects, only: [:name]
  end

  def map_projects
    @projects = Project.eager_load(:locations)
    authorize @projects, :view_allowed?
  end

  def map_covid
    @projects = Project.eager_load(:locations)
    authorize @projects, :view_allowed?
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    if !params[:id].scan(/\D/).empty?
      @project = Project.find_by(slug: params[:id]) || not_found
    else
      @project = Project.find(params[:id]) || not_found
    end

    @project_description = ProjectDescription.where(project_id: @project, locale: I18n.locale).first

    if @project_description.nil?
      @project_description = ProjectDescription.where(project_id: @project, locale: I18n.default_locale).first
    end

    if @project_description.nil?
      @project_description = ProjectDescription.new
    end
  end

  def project_params
    params
      .require(:project)
      .permit(:name, :origin_id, :project_description, :slug, :tags)
      .tap do |attr|
        if params[:reslug].present?
          attr[:slug] = slug_em(attr[:name])
          if params[:duplicate].present?
            first_duplicate = project.slug_starts_with(attr[:slug]).order(slug: :desc).first
            attr[:slug] = attr[:slug] + generate_offset(first_duplicate).to_s
          end
        end
        valid_tags = []
        if params[:project_tags].present?
          valid_tags = params[:project_tags].reject(&:empty?)
        end
        attr[:tags] = valid_tags
      end
  end
end
