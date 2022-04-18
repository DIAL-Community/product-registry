# frozen_string_literal: true

class MovesController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :set_move, only: %i[show edit update destroy]

  # GET /moves
  # GET /moves.json
  def index
    if params[:without_paging]
      @moves = Move.order(:name)
      !params[:search].blank? && @moves = @moves.name_contains(params[:search])
      authorize(Playbooks, :view_allowed?)
      return @moves
    end

    current_page = params[:page] || 1

    @moves = Move.eager_load(:move_descriptions)
    if params[:search]
      @moves = @moves.name_contains(params[:search])
                     .order(:name)
                     .paginate(page: current_page, per_page: 5)
    else
      @moves = @moves.order(:name).paginate(page: current_page, per_page: 5)
    end
    authorize(Playbook, :view_allowed?)
  end

  # GET /move/1
  # GET /move/1.json
  def show
    @parent_play = Play.find_by(slug: params[:play_id]) if params[:play_id]
    if params[:activity_id]
      @parent_playbook = Playbook.find_by(slug: params[:playbook_id])
      @parent_activity = Activity.find_by(slug: params[:activity_id])
    end
    authorize(Playbook, :view_allowed?)
  end

  # GET /moves/new
  def new
    @move = Move.new
    if params[:play_id]
      @play = Play.find_by(slug: params[:play_id])
      @move.plays << @play
    end
    @description = MoveDescription.new
    authorize(Playbook, :mod_allowed?)
  end

  # GET /moves/1/edit
  def edit
    @move.parent_play = params[:play_id] if params[:play_id]
    if params[:activity_id]
      @move.parent_activity = params[:activity_id]
      @move.parent_playbook = params[:playbook_id]
    end
    @description = @move.move_descriptions
                        .select { |desc| desc.locale == I18n.locale.to_s }
                        .first
    authorize(Playbook, :mod_allowed?)
  end

  # POST /moves
  # POST /moves.json
  def create
    @move = Move.new(move_params)
    @move_desc = MoveDescription.new

    authorize(Playbook, :mod_allowed?)

    unless move_params[:parent_play].nil?
      @play = Play.find_by(slug: move_params[:parent_play])
      @move.plays << @play
    end

    params[:selected_organizations]&.keys&.each do |organization_id|
      organization = Organization.find(organization_id)
      @move.organizations.push(organization)
    end

    respond_to do |format|
      if @move.save
        if move_params[:move_description].present?
          @move_desc.move_id = @move.id
          @move_desc.locale = I18n.locale
          @move_desc.description = move_params[:move_description]
          @move_desc.prerequisites = move_params[:move_prerequisites]
          @move_desc.outcomes = move_params[:move_outcomes]
          @move_desc.save
        end

        format.html do
          redirect_to(play_path(@play),
                      notice: t('messages.model.created', model: t('model.move').to_s.humanize))
        end
        format.json { render(:show, status: :created, location: @move) }
      else
        format.html { render(:new) }
        format.json { render(json: @move.errors, status: :unprocessable_entity) }
      end
    end
  end

  # PATCH/PUT /moves/1
  # PATCH/PUT /moves/1.json
  def update
    authorize(Playbook, :mod_allowed?)

    if move_params[:move_desc].present?
      @move_desc = MoveDescription.where(move_id: @move.id,
                                         locale: I18n.locale)
                                  .first || MoveDescription.new
      @move_desc.move_id = @move.id
      @move_desc.locale = I18n.locale
      @move_desc.description = move_params[:move_desc]
      @move_desc.save
    end

    organizations = Set.new
    if params[:selected_organizations].present?
      params[:selected_organizations].keys.each do |organization_id|
        organization = Organization.find(organization_id)
        organizations.add(organization)
      end
    end
    @move.organizations = organizations.to_a

    respond_to do |format|
      if @move.update(move_params)

        @play = Play.find_by(slug: move_params[:parent_play]) unless move_params[:parent_play].nil?

        unless move_params[:parent_activity].nil?
          @activity = Activity.find_by(slug: move_params[:parent_activity])
          @playbook = Playbook.find_by(slug: move_params[:parent_playbook])
        end

        format.html do
          if !@activity.nil?
            redirect_to(playbook_activity_move_path(@playbook, @activity, @move),
                        notice: t('messages.model.updated', model: t('model.move').to_s.humanize))
          else
            redirect_to(play_move_path(@play, @move),
                        notice: t('messages.model.updated', model: t('model.move').to_s.humanize))
          end
        end

        format.json { render(:show, status: :ok, location: @move) }
      else
        format.html { render(:edit) }
        format.json { render(json: @move.errors, status: :unprocessable_entity) }
      end
    end
  end

  # DELETE /moves/1
  # DELETE /moves/1.json
  def destroy
    authorize(Playbook, :mod_allowed?)
    @move.destroy
    respond_to do |format|
      format.html do
        redirect_to(play_move_url,
                    notice: t('messages.model.deleted', model: t('model.move').to_s.humanize))
      end
      format.json { head(:no_content) }
    end
  end

  def duplicates
    @moves = []
    if params[:current].present?
      current_slug = slug_em(params[:current])
      original_slug = slug_em(params[:original])
      @moves = Move.where(slug: current_slug) if current_slug != original_slug
    end
    authorize(Playbook, :view_allowed?)
    render(json: @moves, only: [:name])
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_move
    if !params[:id].scan(/\D/).empty?
      @move = Move.find_by(slug: params[:id]) || not_found
    else
      @move = Move.find(params[:id]) || not_found
    end
    @description = @move.move_descriptions
                        .select { |desc| desc.locale == I18n.locale.to_s }
                        .first
  end

  # Only allow a list of trusted parameters through.
  def move_params
    params.require(:move)
          .permit(:name, :slug, :move_description, :move_prerequisites, :move_outcomes, :description,
                  :complete, :due_date, :order, :media_url, :play_id, :parent_play, :parent_activity,
                  :parent_playbook, resources: %i[
                    name description url
                  ])
          .tap do |attr|
            if params[:reslug].present?
              attr[:slug] = slug_em(attr[:name])
              if params[:duplicate].present?
                first_duplicate = Move.slug_starts_with(attr[:slug]).order(slug: :desc).first
                attr[:slug] = attr[:slug] + generate_offset(first_duplicate).to_s
              end
            end
          end
  end
end
