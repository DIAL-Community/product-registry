class ProjectsController < ApplicationController
  include FilterConcern
  
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_project, only: [:show, :edit, :update, :destroy]

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

  def show
    authorize @project, :view_allowed?
  end

  def new
    authorize Project, :mod_allowed?
    @project = Project.new
    @project_description = ProjectDescription.new
  end

  def create
    authorize Project, :mod_allowed?
    @project = Project.new(project_params)

    if params[:selected_organizations].present?
      params[:selected_organizations].keys.each do |organization_id|
        organization = Organization.find(organization_id)
        @project.organizations.push(organization)
      end
    end

    if params[:selected_products].present?
      params[:selected_products].keys.each do |product_id|
        product = Organization.find(product_id)
        @project.products.push(product)
      end
    end

    respond_to do |format|
      if @project.save!

        if project_params[:project_description].present?
          @project_description = ProjectDescription.new
          @project_description.project_id = @project.id
          @project_description.locale = I18n.locale
          @project_description.description = JSON.parse(project_params[:project_description])
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
    authorize @project, :mod_allowed?
    if params[:selected_organizations].present?
      organizations = Set.new
      params[:selected_organizations].keys.each do |organization_id|
        organization = Organization.find(organization_id)
        organizations.add(organization)
      end
      @project.organizations = organizations.to_a
    end

    if params[:selected_products].present?
      products = Set.new
      params[:selected_products].keys.each do |product_id|
        product = Product.find(product_id)
        products.add(product)
      end
      @project.products = products.to_a
    end

    if project_params[:project_description].present?
      @project_description.project_id = @project.id
      @project_description.locale = I18n.locale
      @project_description.description = JSON.parse(project_params[:project_description])
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

    @project_description = ProjectDescription.where(project_id: @project, locale: I18n.locale)
                                             .first
    if @project_description.nil?
      @project_description = ProjectDescription.new
    end
  end

  def project_params
    params
      .require(:project)
      .permit(:name, :origin_id, :project_description, :slug)
      .tap do |attr|
        if params[:reslug].present?
          attr[:slug] = slug_em(attr[:name])
          if params[:duplicate].present?
            first_duplicate = project.slug_starts_with(attr[:slug]).order(slug: :desc).first
            attr[:slug] = attr[:slug] + generate_offset(first_duplicate).to_s
          end
        end
      end
  end
end
