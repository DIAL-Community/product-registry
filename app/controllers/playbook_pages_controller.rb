class PlaybookPagesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_playbook_page, only: [:show, :edit, :update, :destroy, :copy_page]
  before_action :redirect_cancel, only: [:create, :update, :save_design]

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
    @child_pages = PlaybookPage.where(parent_page_id: @page.id)
  end

  # GET /playbook_pages/new
  def new
    @page = PlaybookPage.new
    @page_contents = PageContent.new
    @page_contents.editor_type = "simple"
    if params[:playbook_id].present?
      @playbook = Playbook.find_by(slug: params[:playbook_id])
      @page.playbook = @playbook
      @pages = PlaybookPage.where(playbook_id: @playbook.id)

      @phases = @playbook.phases.map do |phase|
        phase["name"]
      end
      @pages = PlaybookPage.where(playbook_id: @playbook.id)
    end
    authorize(Playbook, :mod_allowed?)
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
    authorize(Playbook, :mod_allowed?)
  end

  # POST /playbook_pages
  # POST /playbook_pages.json
  def create
    @page = PlaybookPage.new(playbook_page_params)
    authorize(Playbook, :mod_allowed?)

    unless params[:question_text].nil?
      question = PlaybookQuestion.new
      question.question_text = params[:question_text]
      question.locale = I18n.locale

      if params[:answer_texts].present?
        answers = []
        params[:answer_texts].keys.each do |answer_text_key|
          next if answer_text_key.empty? || params[:answer_texts][answer_text_key].empty?

          if answer_text_key.scan(/\D/).empty?
            # Numbers only, so this is an id of the answer text.
            answer = PlaybookAnswer.find(answer_text_key.to_i)
          else
            # Contains text, we need to create new answer
            answer = PlaybookAnswer.new
          end
          answer.answer_text = params[:answer_texts][answer_text_key]
          answer.action = params[:mapped_actions][answer_text_key]
          answer.locale = I18n.locale

          answers << answer
        end
        question.playbook_answers = answers
      end

      @page.playbook_question = question
    end

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
                    notice: t('messages.model.created', model: t('model.playbook-page').to_s.humanize)
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
    authorize(Playbook, :mod_allowed?)

    if @page.playbook_id
      @playbook = Playbook.find(@page.playbook_id)
    end

    unless params[:question_text].nil?
      question = @page.playbook_question
      question.question_text = params[:question_text]
      question.locale = I18n.locale

      if params[:answer_texts].present?
        answers = []
        params[:answer_texts].keys.each do |answer_text_key|
          next if answer_text_key.empty? || params[:answer_texts][answer_text_key].empty?

          if answer_text_key.scan(/\D/).empty?
            # Numbers only, so this is an id of the answer text.
            answer = PlaybookAnswer.find(answer_text_key.to_i)
          else
            # Contains text, we need to create new answer
            answer = PlaybookAnswer.new
          end
          answer.answer_text = params[:answer_texts][answer_text_key]
          answer.action = params[:mapped_actions][answer_text_key]
          answer.locale = I18n.locale

          answers << answer
        end
        question.playbook_answers = answers
      end
    end

    unless playbook_page_params[:content_html].nil?
      @page_contents = PageContent.find_by(playbook_page_id: @page.id)
      unless @page_contents.nil?
        @page_contents.html = playbook_page_params[:content_html]
        @page_contents.css = playbook_page_params[:content_css]
        @page_contents.save!
      end
    end

    respond_to do |format|
      if @page.update(playbook_page_params)
        format.html do
          redirect_to playbook_path(@playbook),
                      notice: t('messages.model.updated', model: t('model.playbook-page').to_s.humanize)
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
                    notice: t('messages.model.deleted', model: t('model.playbook-page').to_s.humanize)
      end
      format.json { head :no_content }
    end
  end

  def copy_page
    authorize Playbook, :mod_allowed?
    @playbook = Playbook.find(@page.playbook_id)

    @new_page = @page.dup
    @new_page.name = @page.name + " Copy"
    @new_page.slug = @page.slug + "_copy"
    @new_page.save!

    @page.page_contents.each do |contents|
      new_contents = contents.dup
      new_contents.playbook_page = @new_page
      new_contents.save!
    end

    new_question = @page.playbook_question.dup
    new_question.playbook_page = @new_page
    new_question.save

    respond_to do |format|
      format.html do
        redirect_to playbook_path(@playbook),
                    notice: t('messages.model.copied', model: t('model.playbook-page').to_s.humanize)
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
    authorize(Playbook, :view_allowed?)
    render(json: @page, only: [:name])
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
    # Currently, we are not using the components, as we need to use html to transfer
    # between simple and page builder editors
    # if !@page_contents.components.nil? && !@page_contents.components.blank?
    #   design['gjs-components'] = @page_contents.components
    # end
    if !@page_contents.html.nil? && !@page_contents.html.blank?
      design['gjs-html'] = @page_contents.html
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

    if params.key?(:editor_type) && params[:editor_type] == "on"
      # This means that it is a page builder and has already been saved
      return respond_to do |format|
        format.html do
          redirect_to playbook_path(@playbook),
                      notice: t('messages.model.created', model: t('model.playbook-page').to_s.humanize)
        end
      end
    end

    if params.has_key?(:page_content)
      @page_contents.html = params['page_content']
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

    @page_contents.locale = params['language'] || I18n.locale

    respond_to do |format|
      if @page_contents.save!
        format.html do
          redirect_to playbook_path(@playbook),
                      notice: t('messages.model.created', model: t('model.playbook-page').to_s.humanize)
        end
        format.json { render json: { design: 'Saved successfully.' }, status: :ok }
      else
        format.html { render :edit_content }
        format.json { render json: { design: 'Saving failed.' }, status: :unprocessable_entity }
      end
    end
  end

  private

  def redirect_cancel
    redirect_to playbook_path(params[:playbook_id]) if params[:cancel]
  end

  def set_page_contents
    language = I18n.locale
    if params['language'].present?
      language = params['language']
    end

    if @page_contents.nil?
      if !params[:id].scan(/\D/).empty?
        @page = PlaybookPage.find_by(slug: params[:id])
        @playbook = Playbook.find(@page.playbook_id)
        @page_contents = PageContent.find_by(playbook_page_id: @page.id, locale: language)
      else
        @page = PlaybookPage.find(params[:id])
        @playbook = Playbook.find(@page.playbook_id)
        @page_contents = PageContent.find_by(playbook_page_id: params[:id], locale: language)
      end

      if @page_contents.nil?
        en_contents = PageContent.find_by(playbook_page_id: @page.id, locale: 'en') if language != 'en'
        @page_contents = en_contents.dup unless en_contents.nil?
        @page_contents = PageContent.new if @page_contents.nil?
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

    language = I18n.locale
    if params['language'].present?
      language = params['language']
    end

    @page_contents = PageContent.where(playbook_page_id: @page, locale: language).first

    if @page_contents.nil?
      @page_contents = PageContent.new
    end
  end

  # Only allow a list of trusted parameters through.
  def playbook_page_params
    params.require(:playbook_page)
          .permit(:name, :slug, :phase, :page_order, :media_url, :question_text, :playbook_id,
                  :parent_page_id, :content_html, :content_css,
                  :editor_type, resources: [:name, :description, :url])
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
