class TasksController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /tasks
  # GET /tasks.json
  def index
    if params[:without_paging]
      @tasks = Task.order(:name)
      !params[:search].blank? && @tasks = @tasks.name_contains(params[:search])
      authorize @tasks, :view_allowed?
      return @tasks
    end

    current_page = params[:page] || 1

    @tasks = Task.order(:name)
    if params[:search]
      @tasks = @tasks.name_contains(params[:search])
                     .paginate(page: current_page, per_page: 5)
    else
      @tasks = @tasks.order(:name).paginate(page: current_page, per_page: 5)
    end
    authorize @tasks, :view_allowed?
  end

  # GET /task/1
  # GET /task/1.json
  def show
    if params[:play_id]
      @parent_play = Play.find_by(slug: params[:play_id])
    end
    if params[:activity_id]
      @parent_playbook = Playbook.find_by(slug: params[:playbook_id])
      @parent_activity = Activity.find_by(slug: params[:activity_id])
    end
    authorize @task, :view_allowed?
  end

  # GET /tasks/new
  def new
    @task = Task.new
    if params[:play_id]
      @task.parent_play = params[:play_id]
    end
    if params[:activity_id]
      @task.parent_activity = params[:activity_id]
      @task.parent_playbook = params[:playbook_id]
      @order = 1
    end
  
    authorize @task, :mod_allowed?
  end

  # GET /tasks/1/edit
  def edit
    if params[:play_id]
      @task.parent_play = params[:play_id]
    end
    if params[:activity_id]
      @task.parent_activity = params[:activity_id]
      @task.parent_playbook = params[:playbook_id]
    end
    @description = @task.task_descriptions
                                   .select { |desc| desc.locale == I18n.locale.to_s }
                                   .first
    authorize @task, :mod_allowed?
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)
    @task_desc = TaskDescription.new

    authorize @task, :mod_allowed?

    if !task_params[:parent_play].nil?
      @play = Play.find_by(slug: task_params[:parent_play])
      @task.plays << @play
    end

    if !task_params[:parent_activity].nil?
      @activity = Activity.find_by(slug: task_params[:parent_activity])
      @playbook = Playbook.find_by(slug: task_params[:parent_playbook])
      @task.activities << @activity
    end

    if (params[:selected_organizations])
      params[:selected_organizations].keys.each do |organization_id|
        organization = Organization.find(organization_id)
        @task.organizations.push(organization)
      end
    end

    respond_to do |format|
      if @task.save
        if task_params[:task_desc].present?
          @task_desc.task_id = @task.id
          @task_desc.locale = I18n.locale
          @task_desc.description = task_params[:task_desc]
          @task_desc.save
        end

        format.html do
          if (!@activity.nil?)
            redirect_to playbook_activity_task_path(@playbook, @activity, @task),
                    notice: t('messages.model.created', model: t('model.task').to_s.humanize)
          else 
            redirect_to play_task_path(@play, @task),
                    notice: t('messages.model.created', model: t('model.task').to_s.humanize)
          end
        end
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    authorize @task, :mod_allowed?

    if task_params[:task_desc].present?
      @task_desc = TaskDescription.where(task_id: @task.id,
                                                              locale: I18n.locale)
                                                        .first || TaskDescription.new
      @task_desc.task_id = @task.id
      @task_desc.locale = I18n.locale
      @task_desc.description = task_params[:task_desc]
      @task_desc.save
    end

    organizations = Set.new
    if params[:selected_organizations].present?
      params[:selected_organizations].keys.each do |organization_id|
        organization = Organization.find(organization_id)
        organizations.add(organization)
      end
    end
    @task.organizations = organizations.to_a

    respond_to do |format|
      if @task.update(task_params)

        if !task_params[:parent_play].nil?
          @play = Play.find_by(slug: task_params[:parent_play])
        end

        if !task_params[:parent_activity].nil?
          @activity = Activity.find_by(slug: task_params[:parent_activity])
          @playbook = Playbook.find_by(slug: task_params[:parent_playbook])
        end
        
        format.html do 
          if (!@activity.nil?)
            redirect_to playbook_activity_task_path(@playbook, @activity, @task),
                    notice: t('messages.model.updated', model: t('model.task').to_s.humanize)
          else 
            redirect_to play_task_path(@play, @task),
                    notice: t('messages.model.updated', model: t('model.task').to_s.humanize)
          end
          
        end

        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    authorize @task, :mod_allowed?
    @task.destroy
    respond_to do |format|
      format.html do
        redirect_to play_task_url,
                    notice: t('messages.model.deleted', model: t('model.task').to_s.humanize)
      end
      format.json { head :no_content }
    end
  end

  def duplicates
    @tasks = Array.new
    if params[:current].present?
      current_slug = slug_em(params[:current])
      original_slug = slug_em(params[:original])
      if current_slug != original_slug
        @tasks = Task.where(slug: current_slug)
      end
    end
    authorize Task, :view_allowed?
    render json: @tasks, only: [:name]
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    if !params[:id].scan(/\D/).empty?
      @task = Task.find_by(slug: params[:id]) || not_found
    else
      @task = Task.find(params[:id]) || not_found
    end
  end

  # Only allow a list of trusted parameters through.
  def task_params
    params.require(:task)
          .permit(:name, :slug, :task_desc, :description, :complete, :due_date, :order, :media_url, :play_id, :parent_play, :parent_activity, :parent_playbook, :resources => [:name, :description, :url])
          .tap do |attr|
            if params[:reslug].present?
              attr[:slug] = slug_em(attr[:name])
              if params[:duplicate].present?
                first_duplicate = Task.slug_starts_with(attr[:slug]).order(slug: :desc).first
                attr[:slug] = attr[:slug] + generate_offset(first_duplicate).to_s
              end
            end
          end
  end
end
