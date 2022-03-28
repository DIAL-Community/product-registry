# frozen_string_literal: true

class PlaysController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :set_play, only: %i[show edit update destroy]

  # GET /plays
  # GET /plays.json
  def index
    if params[:without_paging]
      @plays = Play.order(:name)
      !params[:search].blank? && @plays = @plays.name_contains(params[:search])
      authorize Playbooks, :view_allowed?
      return @plays
    end

    current_page = params[:page] || 1

    @plays = Play.all
    @plays = if params[:search]
               @plays.name_contains(params[:search])
                     .order(:name)
                     .paginate(page: current_page, per_page: 5)
             else
               @plays.order(:name).paginate(page: current_page, per_page: 5)
             end
    authorize Playbook, :view_allowed?
  end

  # GET /play/1
  # GET /play/1.json
  def show
    authorize Playbook, :view_allowed?
  end

  # GET /plays/new
  def new
    @play = Play.new
    @playbook_id = params[:playbook_id] if params[:playbook_id]
    @description = PlayDescription.new
    authorize Playbook, :mod_allowed?
  end

  # GET /plays/1/edit
  def edit
    @play.playbook_id = params[:playbook_id] if params[:playbook_id]
    @play.move_id = params[:move_id] if params[:move_id]
    @description = @play.play_descriptions
                        .select { |desc| desc.locale == I18n.locale.to_s }
                        .first
    authorize Playbook, :mod_allowed?
  end

  # POST /plays
  # POST /plays.json
  def create
    @play = Play.new(play_params)
    @play_desc = PlayDescription.new

    authorize Playbook, :mod_allowed?

    respond_to do |format|
      if @play.save
        if params[:play_description].present? || params[:play_outcomes].present? || params[:play_prerequisites].present?
          @play_desc.play_id = @play.id
          @play_desc.locale = I18n.locale
          params[:play_description].present? && @play_desc.description = params[:play_description]
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

        if params[:playbook_id]
          # Assign it to a playbook immediately
          playbook = Playbook.find_by(slug: params[:playbook_id])
          playbook.playbook_plays << @play
          playbook.save
        end

        format.html do
          if !@move_id.nil?
            redirect_to playbook_move_path(@playbook, @move_id),
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
    authorize Playbook, :mod_allowed?
    if play_params[:play_description].present? || play_params[:play_outcomes].present? || play_params[:play_prerequisites].present?
      @play_desc = PlaybookDescription.where(playbook_id: @play.id,
                                             locale: I18n.locale)
                                      .first || PlayDescription.new
      @play_desc.playbook_id = @play.id
      @play_desc.locale = I18n.locale
      play_params[:play_description].present? && @play_desc.description = play_params[:play_description]
      play_params[:play_prerequisites].present? && @play_desc.prerequisites = play_params[:play_prerequisites]
      play_params[:play_outcomes].present? && @play_desc.outcomes = play_params[:play_outcomes]
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
    authorize Playbook, :mod_allowed?
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
    @play = if !params[:id].scan(/\D/).empty?
              Play.find_by(slug: params[:id]) || not_found
            else
              Play.find(params[:id]) || not_found
            end

    @description = @play.play_descriptions
                        .select { |desc| desc.locale == I18n.locale.to_s }
                        .first
  end

  # Only allow a list of trusted parameters through.
  def play_params
    params.require(:play)
          .permit(:name, :slug, :play_desc, :description_html, :author, :version, :logo, :play_prerequisites, :play_description, :play_outcomes, :playbook_id, :move_id, resources: %i[
                    name description url
                  ])
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
