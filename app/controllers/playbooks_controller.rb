class PlaybooksController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_playbook, only: [:show, :edit, :update, :destroy, :create_pdf, :show_pdf]

  # GET /playbooks
  # GET /playbooks.json
  def index
    if params[:without_paging]
      @playbooks = Playbook.order(:name)
      !params[:search].blank? && @playbooks = @playbooks.name_contains(params[:search])
      authorize @playbooks, :view_allowed?
      return @playbooks
    end

    current_page = params[:page] || 1

    @playbooks = Playbook.eager_load(:playbook_descriptions)
    if params[:search]
      @playbooks = @playbooks.name_contains(params[:search])
                                          .order(:name)
                                          .paginate(page: current_page, per_page: 5)
    else
      @playbooks = @playbooks.order(:name).paginate(page: current_page, per_page: 5)
    end
    authorize @playbooks, :view_allowed?
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

  # GET /playbook/1
  # GET /playbook/1.json
  def show
    authorize @playbook, :view_allowed?
  end

  def show_pdf
  end

  # GET /playbooks/new
  def new
    @playbook = Playbook.new
    @description = PlaybookDescription.new
    authorize @playbook, :mod_allowed?
  end

  # GET /playbooks/1/edit
  def edit
    authorize @playbook, :mod_allowed?
  end

  # POST /playbooks
  # POST /playbooks.json
  def create
    @playbook = Playbook.new(playbook_params)
    @playbook_desc = PlaybookDescription.new

    authorize @playbook, :mod_allowed?

    respond_to do |format|
      if @playbook.save
        @playbook_desc.playbook_id = @playbook.id
        @playbook_desc.locale = I18n.locale
        playbook_params[:playbook_overview].present? && @playbook_desc.overview = playbook_params[:playbook_overview]
        playbook_params[:playbook_audience].present? && @playbook_desc.audience = playbook_params[:playbook_audience]
        playbook_params[:playbook_outcomes].present? && @playbook_desc.outcomes = playbook_params[:playbook_outcomes]
        @playbook_desc.save

        if params[:logo].present?
          uploader = LogoUploader.new(@playbook, params[:logo].original_filename, current_user)
          begin
            uploader.store!(params[:logo])
          rescue StandardError => e
            @playbook.errors.add(:logo, t('errors.messages.extension_whitelist_error'))
          end
        end

        format.html do
          redirect_to @playbook,
                      notice: t('messages.model.created', model: t('model.playbook').to_s.humanize)
        end
        format.json { render :show, status: :created, location: @playbook }
      else
        format.html { render :new }
        format.json { render json: @playbook.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /playbooks/1
  # PATCH/PUT /playbooks/1.json
  def update
    authorize @playbook, :mod_allowed?
    if playbook_params[:playbook_desc].present? || playbook_params[:playbook_audience].present? || playbook_params[:playbook_outcomes].present?
      @playbook_desc = PlaybookDescription.where(playbook_id: @playbook.id,
                                                              locale: I18n.locale)
                                                        .first || PlaybookDescription.new
      @playbook_desc.playbook_id = @playbook.id
      @playbook_desc.locale = I18n.locale
      playbook_params[:playbook_overview].present? && @playbook_desc.overview = playbook_params[:playbook_overview]
      playbook_params[:playbook_audience].present? && @playbook_desc.audience = playbook_params[:playbook_audience]
      playbook_params[:playbook_outcomes].present? && @playbook_desc.outcomes = playbook_params[:playbook_outcomes]
      @playbook_desc.save
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
      if @playbook.update(playbook_params)
        format.html do
          redirect_to @playbook,
                      notice: t('messages.model.updated', model: t('model.playbook').to_s.humanize)
        end
        format.json { render :show, status: :ok, location: @playbook }
      else
        format.html { render :edit }
        format.json { render json: @playbook.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /playbooks/1
  # DELETE /playbooks/1.json
  def destroy
    authorize @playbook, :mod_allowed?
    @playbook.destroy
    respond_to do |format|
      format.html do
        redirect_to playbooks_url,
                    notice: t('messages.model.deleted', model: t('model.playbook').to_s.humanize)
      end
      format.json { head :no_content }
    end
  end

  def create_pdf
    url = request.base_url + "/playbooks/" + @playbook.slug + "/show_pdf"
    pdf_data = Dhalang::PDF.get_from_url(url)
    send_data(pdf_data, filename: @playbook.slug+'.pdf', type: 'application/pdf')
  end

  def duplicates
    @playbook = []
    if params[:current].present?
      current_slug = slug_em(params[:current])
      original_slug = slug_em(params[:original])
      if current_slug != original_slug
        @playbook = Playbook.where(slug: current_slug)
                                          .to_a
      end
    end
    authorize Playbook, :view_allowed?
    render json: @playbook, only: [:name]
    
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_playbook
    if !params[:id].scan(/\D/).empty?
      @playbook = Playbook.find_by(slug: params[:id]) || not_found
    else
      @playbook = Playbook.find(params[:id]) || not_found
    end

    @pages = []
    parent_pages = PlaybookPage.where("playbook_id=? and parent_page_id is null", @playbook.id).order(:page_order)
    parent_pages.each do |page|
      @pages << page
      child_pages = PlaybookPage.where(parent_page_id: page).order(:page_order)
      if !child_pages.empty?
        page.child_pages = []
        child_pages.each do |child_page|
          page.child_pages << child_page
          grandchild_pages = PlaybookPage.where(parent_page_id: child_page).order(:page_order)
          if !grandchild_pages.empty?
            child_page.child_pages = []
            grandchild_pages.each do |grandchild_page|
              child_page.child_pages << grandchild_page
            end
          end
        end
      end
    end

    @description = @playbook.playbook_descriptions
                                 .select { |desc| desc.locale == I18n.locale.to_s }
                                 .first
  end

  # Only allow a list of trusted parameters through.
  def playbook_params
    params.require(:playbook)
          .permit(:name, :slug, :playbook_overview, :playbook_audience, :playbook_outcomes, :logo, :maturity, :phases => [:name, :description])
          .tap do |attr|
            if params[:reslug].present?
              attr[:slug] = slug_em(attr[:name])
              if params[:duplicate].present?
                first_duplicate = Playbook.slug_starts_with(attr[:slug]).order(slug: :desc).first
                attr[:slug] = attr[:slug] + generate_offset(first_duplicate).to_s
              end
            end
          end
  end
  helper_method :create_pdf
end
