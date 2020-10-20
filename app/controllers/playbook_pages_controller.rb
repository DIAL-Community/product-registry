class PlaybookPagesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_playbook_page, only: [:show, :edit, :update, :destroy]

  # GET /playbook_pages
  # GET /playbook_pages.json
  def index
    if params[:without_paging]
      @pages = PlaybookPage.order(:name)
      !params[:search].blank? && @pages = @pages.name_contains(params[:search])
      authorize Playbook, :view_allowed?
      return @pages
    end

    current_page = params[:page] || 1

    @pages = PlaybookPage.order(:name)
    if params[:search]
      @pages = @pages.name_contains(params[:search])
                     .order(:name)
                     .paginate(page: current_page, per_page: 5)
    else
      @pages = @pages.order(:name).paginate(page: current_page, per_page: 5)
    end
    authorize Playbook, :view_allowed?
  end

  # GET /playbook_page/1
  # GET /playbook_page/1.json
  def show
    if params[:playbook_id]
      @playbook = Playbook.find_by(slug: params[:playbook_id])
    end
  end

  # GET /playbook_pages/new
  def new
    @page = PlaybookPage.new
    @page_contents = PageContent.new
    @page_contents.editor_type = "simple"
    if params[:playbook_id]
      @playbook = Playbook.find_by(slug: params[:playbook_id])
      @page.playbook = @playbook
      @pages = PlaybookPage.where(playbook_id: @playbook.id)
      
      @phases = @playbook.phases.map do |phase|
        phase["name"]
      end
    end
    authorize Playbook, :mod_allowed?
  end

  # GET /playbook_pages/1/edit
  def edit
    if params[:playbook_id]
      @playbook = Playbook.find_by(slug: params[:playbook_id])
      @phases = @playbook.phases.map do |phase|
        phase["name"]
      end
      @pages = PlaybookPage.where(playbook_id: @playbook.id)
    end
    authorize Playbook, :mod_allowed?
  end

  # POST /playbook_pages
  # POST /playbook_pages.json
  def create
    @page = PlaybookPage.new(playbook_page_params)
    if !playbook_page_params[:question_text].nil?
      question = PlaybookQuestion.new
      question.question_text = playbook_page_params[:question_text]
      question.save!
      @page.playbook_questions_id = question.id
    end
    authorize Playbook, :mod_allowed?
    @page.slug = slug_em(@page.name)

    if playbook_page_params[:playbook_id]
      @playbook = Playbook.find(playbook_page_params[:playbook_id])
      @page.playbook_id = @playbook
      @playbook.playbook_pages << @page
      @playbook.save
    end

    respond_to do |format|
      if @page.save
        format.html do
          redirect_to @playbook,
                    notice: t('messages.model.created', model: t('model.playbook_page').to_s.humanize)
        end
        format.json { render :show, status: :created, location: @page }
      else
        format.html { render :new }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /playbook_pages/1
  # PATCH/PUT /playbook_pages/1.json
  def update
    authorize Playbook, :mod_allowed?
    

    if @page.playbook_id
      @playbook = Playbook.find(@page.playbook_id)
    end

    if !playbook_page_params[:question_text].nil?
      question = @page.playbook_questions_id.nil? ? PlaybookQuestion.new : PlaybookQuestion.find(@page.playbook_questions_id)
      question.question_text = playbook_page_params[:question_text]
      question.save!
      @page.playbook_questions_id = question.id
    end

    respond_to do |format|
      if @page.update(playbook_page_params)
        format.html do
          redirect_to playbook_path(@playbook),
                      notice: t('messages.model.updated', model: t('model.playbook_page').to_s.humanize)
        end
        format.json { render :show, status: :ok, location: @page }
      else
        format.html { render :edit }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /playbook_pages/1
  # DELETE /playbook_pages/1.json
  def destroy
    authorize Playbook, :mod_allowed?
    @playbook = Playbook.find(@page.playbook_id)

    @page.destroy
    respond_to do |format|
      format.html do
        redirect_to playbook_path(@playbook),
                    notice: t('messages.model.deleted', model: t('model.playbook_page').to_s.humanize)
      end
      format.json { head :no_content }
    end
  end

  def duplicates
    @page = []
    if params[:current].present?
      current_slug = slug_em(params[:current])
      original_slug = slug_em(params[:original])
      if current_slug != original_slug
        @page = PlaybookPage.where(slug: current_slug).to_a                       
      end
    end
    authorize Activity, :view_allowed?
    render json: @page, only: [:name]
  end

  def upload_design_images
    uploaded_filenames = []
    uploaded_files = params[:files]
    root_rails = Rails.root.join('public', 'assets', 'playbooks', 'design_images') 
    uploaded_files.each do |uploaded_file|
      File.open("#{root_rails}/#{uploaded_file.original_filename}", 'wb') do |file|
        file.write(uploaded_file.read)
        uploaded_filenames << "/assets/playbooks/design_images/#{uploaded_file.original_filename}"
      end
    end

    respond_to { |format| format.json { render json: { data: uploaded_filenames }, status: :ok } }
  end

  def edit_content
    set_page_contents
  end

  def load_design
    set_page_contents

    design = {}
    if !@page_contents.components.nil? && !@page_contents.components.blank?
      design['gjs-components'] = @page_contents.components
    end
    if !@page_contents.styles.nil? && !@page_contents.styles.blank?
      design['gjs-styles'] = @page_contents.styles
    end
    if !@page_contents.assets.nil? && !@page_contents.assets.blank?
      design['gjs-assets'] = @page_contents.assets
    end

    respond_to { |format| format.json { render json: design, status: :ok } }
  end

  def save_design
    set_page_contents

    if current_user.nil? || @page_contents.nil?
      return respond_to { |format| format.json { render json: {}, status: :unauthorized } }
    end

    if params.has_key?(:editor_type) && params[:editor_type] == "on"
      # This means that it is a page builder and has already been saved
      return respond_to { |format| format.html { redirect_to playbook_path(@playbook),
            notice: t('messages.model.created', model: t('model.playbook-page').to_s.humanize) } }
    end

    if params.has_key?(:page_content)
      @page_contents.html = params['page_content']['page_html']
      @page_contents.css = ""
      @page_contents.editor_type = "simple"
    else
      @page_contents.css = params['gjs-css']
      @page_contents.html = params['gjs-html']
      @page_contents.styles = params['gjs-styles']
      @page_contents.components = params['gjs-components']
      @page_contents.assets = params['gjs-assets']
      @page_contents.editor_type = "builder"
    end

    @page_contents.locale = I18n.locale

    respond_to do |format|
      if @page_contents.save!
        format.html do
          redirect_to playbook_path(@playbook),
                      notice: t('messages.model.created', model: t('model.playbook-page').to_s.humanize)
        end
        format.json do
          redirect_to playbook_path(@playbook, format: :html),
            notice: t('messages.model.created', model: t('model.playbook-page').to_s.humanize)

        end
      else
        format.html { render :edit_content }
        format.json { render json: { design: 'Saving failed.' }, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_page_contents
    if @page_contents.nil?
      if !params[:id].scan(/\D/).empty?
        @page = PlaybookPage.find_by(slug: params[:id])
        @playbook = Playbook.find(@page.playbook_id)
        @page_contents = PageContent.find_by(playbook_page_id: @page.id)
      else
        @page = PlaybookPage.find(params[:id])
        @playbook = Playbook.find(@page.playbook_id)
        @page_contents = PageContent.find_by(playbook_page_id: params[:id])
      end
      if @page_contents.nil? 
        @page_contents = PageContent.new
        @page_contents.playbook_page_id = @page.id
        @page_contents.editor_type = "simple"
      end
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_playbook_page
    if !params[:id].scan(/\D/).empty?
      @page = PlaybookPage.find_by(slug: params[:id]) || not_found
    else
      @page = PlaybookPage.find(params[:id]) || not_found
    end

    @page_contents = PageContent.where(playbook_page_id: @page, locale: I18n.locale).first

    if @page_contents.nil?
      @page_contents = PageContent.new
    end

    if !@page.playbook_questions_id.nil?
      @question = PlaybookQuestion.find(@page.playbook_questions_id)
      @answers = PlaybookAnswer.find_by(playbook_questions_id: @page.playbook_questions_id)
    end
  end

  # Only allow a list of trusted parameters through.
  def playbook_page_params
    params.require(:playbook_page)
      .permit(:name, :slug, :phase, :page_order, :media_url, :question_text, :playbook_id, :parent_page_id, :editor_type,
             :resources => [:name, :description, :url])
      .tap do |attr|
        if params[:reslug].present?
          attr[:slug] = slug_em(attr[:name])
          if params[:duplicate].present?
            first_duplicate = PlaybookPage.slug_starts_with(attr[:slug]).order(slug: :desc).first
            attr[:slug] = attr[:slug] + generate_offset(first_duplicate).to_s
          end
        end
      end
  end
end
