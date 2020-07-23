class TaskTrackersController < ApplicationController
  before_action :set_task_tracker, only: [:show, :edit, :update, :destroy]

  # GET /task_trackers
  # GET /task_trackers.json
  def index
    if params[:without_paging]
      @task_trackers = TaskTracker.order(:name)
      !params[:search].blank? && @task_trackers = @task_trackers.name_contains(params[:search])
      authorize(@task_trackers, :view_allowed?)
      return @task_trackers
    end

    current_page = params[:page] || 1
    puts "Current page : #{current_page}."

    @task_tracker = TaskTracker.eager_load(:task_tracker_descriptions)
    if params[:search].present?
      @task_trackers = @task_tracker.name_contains(params[:search])
                                    .order(:name)
                                    .paginate(page: current_page, per_page: 5)
    else
      @task_trackers = @task_tracker.order(:name)
                                    .paginate(page: current_page, per_page: 5)
    end
    puts "Task : #{@task_trackers.inspect}."
    authorize(@task_trackers, :view_allowed?)
  end

  # GET /task_trackers/1
  # GET /task_trackers/1.json
  def show
    authorize(TaskTracker, :view_allowed?)
  end

  # GET /task_trackers/new
  def new
    authorize(TaskTracker, :mod_allowed?)
    @task_tracker = TaskTracker.new
  end

  # GET /task_trackers/1/edit
  def edit
    authorize(TaskTracker, :mod_allowed?)
  end

  # POST /task_trackers
  # POST /task_trackers.json
  def create
    authorize(TaskTracker, :mod_allowed?)
    @task_tracker = TaskTracker.new(task_tracker_params)
    @task_tracker_description = TaskTrackerDescription.new

    respond_to do |format|
      if @task_tracker.save
        if task_tracker_params[:tt_desc].present?
          @task_tracker_description.task_tracker = @task_tracker
          @task_tracker_description.locale = I18n.locale
          @task_tracker_description.description = JSON.parse(task_tracker_params[:tt_desc])
          @task_tracker_description.save
        end
        format.html do
          redirect_to @task_tracker, notice: t('messages.model.created',
                      model: t('model.task-tracker').to_s.humanize)
        end
        format.json { render :show, status: :created, location: @task_tracker }
      else
        format.html { render :new }
        format.json { render json: @task_tracker.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /task_trackers/1
  # PATCH/PUT /task_trackers/1.json
  def update
    authorize(@task_tracker, :mod_allowed?)
    if task_tracker_params[:tt_desc].present?
      @task_tracker_description = TaskTrackerDescription.where(task_tracker: @task_tracker,
                                                               locale: I18n.locale)
                                                        .first || TaskTrackerDescription.new
      @task_tracker_description.task_tracker = @task_tracker
      @task_tracker_description.locale = I18n.locale
      @task_tracker_description.description = JSON.parse(task_tracker_params[:tt_desc])
      @task_tracker_description.save
    end

    respond_to do |format|
      if @task_tracker.update(task_tracker_params)
        format.html do
          redirect_to @task_tracker, notice: t('messages.model.updated',
                      model: t('model.task-tracker').to_s.humanize)
        end
        format.json { render :show, status: :ok, location: @task_tracker }
      else
        format.html { render :edit }
        format.json { render json: @task_tracker.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /task_trackers/1
  # DELETE /task_trackers/1.json
  def destroy
    @task_tracker.destroy
    respond_to do |format|
      format.html { redirect_to task_trackers_url, notice: 'Task tracker was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def duplicates
    @task_trackers = []
    if params[:current].present?
      current_slug = slug_em(params[:current])
      original_slug = slug_em(params[:original])
      if current_slug != original_slug
        @task_trackers = TaskTracker.where(slug: current_slug)
                                    .to_a
      end
    end
    render(json: @task_trackers, only: [:name])
    authorize(@task_trackers, :view_allowed?)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task_tracker
    @task_tracker = TaskTracker.find_by(slug: params[:id])
  end

  # Only allow a list of trusted parameters through.
  def task_tracker_params
    params.require(:task_tracker)
          .permit(:name, :slug, :last_run, :tt_desc)
          .tap do |attr|
            if params[:reslug].present?
              attr[:slug] = slug_em(attr[:name])
              if params[:duplicate].present?
                first_duplicate = TaskTracker.slug_starts_with(attr[:slug]).order(slug: :desc).first
                attr[:slug] = attr[:slug] + generate_offset(first_duplicate).to_s
              end
            end
          end
  end
end
