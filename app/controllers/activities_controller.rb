class ActivitiesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_activity, only: [:show, :edit, :update, :destroy]

  # GET /activities
  # GET /activities.json
  def index
    if params[:without_paging]
      @activities = Activity.order(:name)
      !params[:search].blank? && @activities = @activities.name_contains(params[:search])
      authorize @activities, :view_allowed?
      return @activities
    end

    current_page = params[:page] || 1

    @activities = Activity.order(:name)
    if params[:search]
      @activities = @activities.name_contains(params[:search])
                                          .order(:name)
                                          .paginate(page: current_page, per_page: 5)
    else
      @activities = @activities.order(:name).paginate(page: current_page, per_page: 5)
    end
    authorize @activities, :view_allowed?
  end

  # GET /activity/1
  # GET /activity/1.json
  def show
    if params[:playbook_id]
      @playbook = Playbook.find_by(slug: params[:playbook_id])
    end
    authorize @activity, :view_allowed?
  end

  # GET /activities/new
  def new
    @activity = Activity.new
    if params[:playbook_id]
      @activity.playbook_id = params[:playbook_id]
      @playbook = Playbook.find_by(slug: params[:playbook_id])
      @phases = @playbook.phases.map do |phase|
        phase["name"]
      end
    end
    @plays = Play.all
    authorize @activity, :mod_allowed?
  end

  # GET /activities/1/edit
  def edit
    if params[:playbook_id]
      @playbook = Playbook.find_by(slug: params[:playbook_id])
      @phases = @playbook.phases.map do |phase|
        phase["name"]
      end
    end
    authorize @activity, :mod_allowed?
  end

  # POST /activities
  # POST /activities.json
  def create
    if activity_params[:name] == "Assign-From-Play"
      params[:play_ids].each do |play_id|
        @activity = Activity.new
        authorize @activity, :mod_allowed?
        @play = Play.find(play_id)
        @activity.name = @play.name
        first_duplicate = Activity.slug_starts_with(@play.slug).order(slug: :desc).first
        @activity.slug = @play.slug + generate_offset(first_duplicate).to_s
        @activity.resources = @play.resources
        @activity.description = @play.description
        @activity.phase = activity_params[:phase]
        @play.tasks.each do |task|
          activity_task = task.dup
          first_duplicate = Task.slug_starts_with(task.slug).order(slug: :desc).first
          activity_task.slug = task.slug + generate_offset(first_duplicate).to_s
          activity_task.save!
          task_desc = TaskDescription.where(task_id: task.id, locale: I18n.locale).first
          activity_task_desc = task_desc.dup
          activity_task_desc.task_id = activity_task.id
          activity_task_desc.save
          @activity.tasks << activity_task
        end
      end
    else
      @activity = Activity.new(activity_params)
      if !activity_params[:question_text].nil?
        question = PlaybookQuestion.new
        question.question_text = activity_params[:question_text]
        question.save!
        @activity.playbook_questions_id = question.id
      end
      authorize @activity, :mod_allowed?
      @activity.slug = slug_em(@activity.name)
    end

    if activity_params[:playbook_id]
      @playbook = Playbook.find_by(slug: activity_params[:playbook_id])
      @activity.playbook_id = @playbook
      @playbook.activities << @activity
      @playbook.save
    end

    respond_to do |format|
      if @activity.save
        format.html do
          redirect_to playbook_path(@playbook),
                    notice: t('messages.model.created', model: t('model.activity').to_s.humanize)
        end
        format.json { render :show, status: :created, location: @activity }
      else
        format.html { render :new }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activities/1
  # PATCH/PUT /activities/1.json
  def update
    authorize @activity, :mod_allowed?

    if @activity.playbook_id
      @playbook = Playbook.find(@activity.playbook_id)
    end

    if !activity_params[:question_text].nil?
      question = @activity.playbook_questions_id.nil? ? PlaybookQuestion.new : PlaybookQuestion.find(@activity.playbook_questions_id)
      question.question_text = activity_params[:question_text]
      question.save!
      @activity.playbook_questions_id = question.id
    end
    
    respond_to do |format|
      if @activity.update(activity_params)
        format.html do
          redirect_to playbook_path(@playbook),
                      notice: t('messages.model.updated', model: t('model.activity').to_s.humanize)
        end
        format.json { render :show, status: :ok, location: @activity }
      else
        format.html { render :edit }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activities/1
  # DELETE /activities/1.json
  def destroy
    authorize @activity, :mod_allowed?
    @playbook = Playbook.find(@activity.playbook_id)

    @activity.tasks.each do |task|
      task.destroy
    end

    @activity.destroy
    respond_to do |format|
      format.html do
        redirect_to playbook_path(@playbook),
                    notice: t('messages.model.deleted', model: t('model.activity').to_s.humanize)
      end
      format.json { head :no_content }
    end
  end

  def duplicates
    @activity = []
    if params[:current].present?
      current_slug = slug_em(params[:current])
      original_slug = slug_em(params[:original])
      if current_slug != original_slug
        @activity = Activity.where(slug: current_slug)
                                          .to_a
      end
    end
    authorize Activity, :view_allowed?
    render json: @activity, only: [:name]
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_activity
    if !params[:id].scan(/\D/).empty?
      @activity = Activity.find_by(slug: params[:id]) || not_found
    else
      @activity = Activity.find(params[:id]) || not_found
    end
    if !@activity.playbook_questions_id.nil?
      @question = PlaybookQuestion.find(@activity.playbook_questions_id)
      @answers = PlaybookAnswer.find_by(playbook_questions_id: @activity.playbook_questions_id)
    end
  end

  # Only allow a list of trusted parameters through.
  def activity_params
    params.require(:activity)
      .permit(:name, :slug, :description, :phase, :order, :media_url, :question_text, :playbook_id, :resources => [:name, :description, :url])
      .tap do |attr|
        if params[:reslug].present?
          attr[:slug] = slug_em(attr[:name])
          if params[:duplicate].present?
            first_duplicate = Activity.slug_starts_with(attr[:slug]).order(slug: :desc).first
            attr[:slug] = attr[:slug] + generate_offset(first_duplicate).to_s
          end
        end
      end
  end
end