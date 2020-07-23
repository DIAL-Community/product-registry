class PlaysController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_play, only: [:show, :edit, :update, :destroy]

  # GET /plays
  # GET /plays.json
  def index
    if params[:without_paging]
      @plays = Play.order(:name)
      !params[:search].blank? && @plays = @plays.name_contains(params[:search])
      authorize @plays, :view_allowed?
      return @plays
    end

    current_page = params[:page] || 1

    @plays = Play.all
    if params[:search]
      @plays = @plays.name_contains(params[:search])
                                          .order(:name)
                                          .paginate(page: current_page, per_page: 5)
    else
      @plays = @plays.order(:name).paginate(page: current_page, per_page: 5)
    end
    authorize @plays, :view_allowed?
  end

  # GET /play/1
  # GET /play/1.json
  def show
    if params[:activity_id]
      @activity = Activity.find_by(slug: params[:activity_id])
      @playbook = Playbook.find(@activity.playbook_id)
    end
    authorize @play, :view_allowed?
  end

  # GET /plays/new
  def new
    @play = Play.new
    if params[:playbook_id]
      @play.playbook_id = params[:playbook_id]
    end
    if params[:activity_id]
      @play.activity_id = params[:activity_id]
    end
    @description = PlayDescription.new
    authorize @play, :mod_allowed?
  end

  # GET /plays/1/edit
  def edit
    if params[:playbook_id]
      @play.playbook_id = params[:playbook_id]
    end
    if params[:activity_id]
      @play.activity_id = params[:activity_id]
    end
    @description = @play.play_descriptions
                                 .select { |desc| desc.locale == I18n.locale.to_s }
                                 .first
    authorize @play, :mod_allowed?
  end

  # POST /plays
  # POST /plays.json
  def create
    @play = Play.new(play_params)
    @play_desc = PlayDescription.new

    authorize @play, :mod_allowed?

    respond_to do |format|
      if @play.save
        if params[:play_description].present? || params[:play_outcomes].present? || params[:play_prerequisites].present?
          @play_desc.play_id = @play.id
          @play_desc.locale = I18n.locale
          params[:play_description].present? && @play_desc.description = JSON.parse(params[:play_description])
          params[:play_prerequisites].present? && @play_desc.prerequisites = JSON.parse(params[:play_prerequisites])
          params[:play_outcomes].present? && @play_desc.outcomes = JSON.parse(params[:play_outcomes])
          @play_desc.save
        end

        if params[:logo].present?
          uploader = LogoUploader.new(@playbook, params[:logo].original_filename, current_user)
          begin
            uploader.store!(params[:logo])
          rescue StandardError => e
            @playbook.errors.add(:logo, t('errors.messages.extension_whitelist_error'))
          end
        end

        if play_params[:activity_id]
          @activity = Activity.find_by(slug: play_params[:activity_id])
          @playbook = Playbook.find(@activity.playbook_id)
          @activity.plays << @play
          @activity.save
        end

        format.html do
          if (!@activity.nil?)
            redirect_to playbook_activity_path(@playbook, @activity),
                      notice: t('messages.model.created', model: t('model.play').to_s.humanize)
          else
            redirect_to @play,
                      notice: t('messages.model.created', model: t('model.play').to_s.humanize)
          end
        end
        format.json { render :show, status: :created, location: @play }
      else
        format.html { render :new }
        format.json { render json: @play.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /plays/1
  # PATCH/PUT /plays/1.json
  def update
    authorize @play, :mod_allowed?
    if play_params[:play_description].present? || play_params[:play_outcomes].present? || play_params[:play_prerequisites].present?
      @play_desc = PlaybookDescription.where(playbook_id: @play.id,
                                                              locale: I18n.locale)
                                                        .first || PlayDescription.new
      @play_desc.playbook_id = @play.id
      @play_desc.locale = I18n.locale
      play_params[:play_description].present? && @play_desc.description = JSON.parse(play_params[:play_description])
      play_params[:play_prerequisites].present? && @play_desc.prerequisites = JSON.parse(play_params[:play_prerequisites])
      play_params[:play_outcomes].present? && @play_desc.outcomes = JSON.parse(play_params[:play_outcomes])
      @play_desc.save
    end

    if params[:logo].present?
      uploader = LogoUploader.new(@playbook, params[:logo].original_filename, current_user)
      begin
        uploader.store!(params[:logo])
      rescue StandardError => e
        @playbook.errors.add(:logo, t('errors.messages.extension_whitelist_error'))
      end
    end
    
    respond_to do |format|
      if @play.update(play_params)
        format.html do
          redirect_to @play,
                      notice: t('messages.model.updated', model: t('model.play').to_s.humanize)
        end
        format.json { render :show, status: :ok, location: @play }
      else
        format.html { render :edit }
        format.json { render json: @play.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plays/1
  # DELETE /plays/1.json
  def destroy
    authorize @play, :mod_allowed?
    @play.destroy
    respond_to do |format|
      format.html do
        redirect_to plays_url,
                    notice: t('messages.model.deleted', model: t('model.play').to_s.humanize)
      end
      format.json { head :no_content }
    end
  end

  def duplicates
    @play = []
    if params[:current].present?
      current_slug = slug_em(params[:current])
      original_slug = slug_em(params[:original])
      if current_slug != original_slug
        @play = Play.where(slug: current_slug)
                                          .to_a
      end
    end
    authorize Play, :view_allowed?
    render json: @play, only: [:name]
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_play
    if !params[:id].scan(/\D/).empty?
      @play = Play.find_by(slug: params[:id]) || not_found
    else
      @play = Play.find(params[:id]) || not_found
    end
  end

  # Only allow a list of trusted parameters through.
  def play_params
    params.require(:play)
      .permit(:name, :slug, :play_desc, :description_html, :author, :version, :logo, :play_prerequisites, :play_description, :play_outcomes, :playbook_id, :activity_id, :resources => [:name, :description, :url])
      .tap do |attr|
        if params[:reslug].present?
          attr[:slug] = slug_em(attr[:name])
          if params[:duplicate].present?
            first_duplicate = Play.slug_starts_with(attr[:slug]).order(slug: :desc).first
            attr[:slug] = attr[:slug] + generate_offset(first_duplicate).to_s
          end
        end
      end
  end
end
