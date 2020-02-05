class ProjectsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    if params[:search]
      @projects = Project.where('LOWER(name) like LOWER(?)', "%#{params[:search]}%")
                         .order(:name)
    else
      @projects = Project.all
                         .paginate(page: params[:page], per_page: 20)
                         .order(:name)
    end
    authorize @projects, :view_allowed?
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
        @projects = project.where(slug: current_slug).to_a
      end
    end
    authorize Project, :view_allowed?
    render json: @projects, only: [:name]
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
