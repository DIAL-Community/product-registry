# frozen_string_literal: true

require 'combine_pdf'
require 'pdfkit'
require 'tempfile'

class HandbooksController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :set_handbook, only: %i[show edit update destroy create_pdf show_pdf]

  # GET /handbooks
  # GET /handbooks.json
  def index
    if params[:without_paging]
      @handbooks = Handbook.order(:name)
      !params[:search].blank? && @handbooks = @handbooks.name_contains(params[:search])
      authorize @handbooks, :view_allowed?
      return @handbooks
    end

    current_page = params[:page] || 1

    @handbooks = Handbook.order(:name)
    @handbooks = if params[:search]
                   @handbooks.name_contains(params[:search])
                             .paginate(page: current_page, per_page: 5)
                 else
                   @handbooks.paginate(page: current_page, per_page: 5)
                 end
    authorize @handbooks, :view_allowed?
  end

  def upload_design_images
    uploaded_filenames = []
    uploaded_files = params[:files]
    root_rails = Rails.root.join('public', 'assets', 'handbooks', 'design_images')
    uploaded_files.each do |uploaded_file|
      File.open("#{root_rails}/#{uploaded_file.original_filename}", 'wb') do |file|
        file.write(uploaded_file.read)
        uploaded_filenames << "/assets/handbooks/design_images/#{uploaded_file.original_filename}"
      end
    end

    respond_to { |format| format.json { render json: { data: uploaded_filenames }, status: :ok } }
  end

  # GET /handbook/1
  # GET /handbook/1.json
  def show
    authorize @handbook, :view_allowed?
  end

  def show_pdf; end

  # GET /handbooks/new
  def new
    @handbook = Handbook.new
    @description = HandbookDescription.new
    authorize @handbook, :mod_allowed?
  end

  # GET /handbooks/1/edit
  def edit
    authorize @handbook, :mod_allowed?
  end

  # POST /handbooks
  # POST /handbooks.json
  def create
    @handbook = Handbook.new(handbook_params)
    @handbook_desc = HandbookDescription.new

    authorize @handbook, :mod_allowed?

    respond_to do |format|
      if @handbook.save
        @handbook_desc.handbook_id = @handbook.id
        @handbook_desc.locale = I18n.locale
        handbook_params[:handbook_overview].present? && @handbook_desc.overview = handbook_params[:handbook_overview]
        handbook_params[:handbook_audience].present? && @handbook_desc.audience = handbook_params[:handbook_audience]
        handbook_params[:handbook_outcomes].present? && @handbook_desc.outcomes = handbook_params[:handbook_outcomes]
        handbook_params[:handbook_cover].present? && @handbook_desc.cover = handbook_params[:handbook_cover]
        @handbook_desc.save

        if params[:logo].present?
          uploader = LogoUploader.new(@handbook, params[:logo].original_filename, current_user)
          begin
            uploader.store!(params[:logo])
          rescue StandardError => e
            @handbook.errors.add(:logo, t('errors.messages.extension_whitelist_error'))
          end
        end

        format.html do
          redirect_to @handbook,
                      notice: t('messages.model.created', model: t('model.handbook').to_s.humanize)
        end
        format.json { render :show, status: :created, location: @handbook }
      else
        format.html { render :new }
        format.json { render json: @handbook.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /handbooks/1
  # PATCH/PUT /handbooks/1.json
  def update
    authorize @handbook, :mod_allowed?
    if handbook_params[:handbook_overview].present? || handbook_params[:handbook_audience].present? || handbook_params[:handbook_outcomes].present? || handbook_params[:handbook_cover].present?
      @handbook_desc = HandbookDescription.where(handbook_id: @handbook.id,
                                                 locale: I18n.locale)
                                          .first || HandbookDescription.new
      @handbook_desc.handbook_id = @handbook.id
      @handbook_desc.locale = I18n.locale
      handbook_params[:handbook_overview].present? && @handbook_desc.overview = handbook_params[:handbook_overview]
      handbook_params[:handbook_audience].present? && @handbook_desc.audience = handbook_params[:handbook_audience]
      handbook_params[:handbook_outcomes].present? && @handbook_desc.outcomes = handbook_params[:handbook_outcomes]
      handbook_params[:handbook_cover].present? && @handbook_desc.cover = handbook_params[:handbook_cover]
      @handbook_desc.save
    end

    if params[:logo].present?
      uploader = LogoUploader.new(@handbook, params[:logo].original_filename, current_user)
      begin
        uploader.store!(params[:logo])
      rescue StandardError => e
        @handbook.errors.add(:logo, t('errors.messages.extension_whitelist_error'))
      end
    end

    respond_to do |format|
      if @handbook.update(handbook_params)
        format.html do
          redirect_to @handbook,
                      notice: t('messages.model.updated', model: t('model.handbook').to_s.humanize)
        end
        format.json { render :show, status: :ok, location: @handbook }
      else
        format.html { render :edit }
        format.json { render json: @handbook.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /handbooks/1
  # DELETE /handbooks/1.json
  def destroy
    authorize @handbook, :mod_allowed?
    @handbook.destroy
    respond_to do |format|
      format.html do
        redirect_to handbooks_url,
                    notice: t('messages.model.deleted', model: t('model.handbook').to_s.humanize)
      end
      format.json { head :no_content }
    end
  end

  def create_pdf
    url = "#{request.base_url}/handbooks/#{@handbook.slug}/show_pdf"
    pdf_data = Dhalang::PDF.get_from_url(url)
    send_data(pdf_data, filename: "#{@handbook.slug}.pdf", type: 'application/pdf')
  end

  def duplicates
    @handbook = []
    if params[:current].present?
      current_slug = slug_em(params[:current])
      original_slug = slug_em(params[:original])
      if current_slug != original_slug
        @handbook = Handbook.where(slug: current_slug)
                            .to_a
      end
    end
    authorize Handbook, :view_allowed?
    render json: @handbook, only: [:name]
  end

  def convert_pages
    format.json { render json: {}, status: :unprocessable_entity } unless params[:page_ids].present?

    base_filename = ''
    combined_pdfs = CombinePDF.new

    params[:page_ids].each do |page_id|
      base_filename += "#{page_id}-"

      page_content = PageContent.find_by(handbook_page_id: page_id, locale: 'en')
      next if page_content.nil? || page_content.html.nil?

      pdf_data = PDFKit.new(page_content.html, page_size: 'Letter')
      pdf_data.stylesheets = page_content.css if page_content.editor_type != 'simple'

      temporary = Tempfile.new(Time.now.strftime('%s'))
      pdf_data.to_file(temporary.path)

      combined_pdfs << CombinePDF.load(temporary.path)
    end

    temporary = Tempfile.new(Time.now.strftime('%s'))
    combined_pdfs.save(temporary.path)

    json = {}
    json['filename'] = "Page-#{base_filename}-exported.pdf"
    json['content_type'] = 'application/pdf'
    json['data'] = Base64.strict_encode64(File.read(temporary.path))

    respond_to do |format|
      format.json { render json: json }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_handbook
    @handbook = if !params[:id].scan(/\D/).empty?
                  Handbook.find_by(slug: params[:id]) || not_found
                else
                  Handbook.find(params[:id]) || not_found
                end

    @pages = []
    parent_pages = HandbookPage.where('handbook_id=? and parent_page_id is null', @handbook.id).order(:page_order)
    parent_pages.each do |page|
      @pages << page
      child_pages = HandbookPage.where(parent_page_id: page).order(:page_order)
      next if child_pages.empty?

      page.child_pages = []
      child_pages.each do |child_page|
        page.child_pages << child_page
        grandchild_pages = HandbookPage.where(parent_page_id: child_page).order(:page_order)
        next if grandchild_pages.empty?

        child_page.child_pages = []
        grandchild_pages.each do |grandchild_page|
          child_page.child_pages << grandchild_page
        end
      end
    end

    @description = @handbook.handbook_descriptions
                            .select { |desc| desc.locale == I18n.locale.to_s }
                            .first
  end

  # Only allow a list of trusted parameters through.
  def handbook_params
    params.require(:handbook)
          .permit(:name, :slug, :handbook_overview, :handbook_audience, :handbook_outcomes, :handbook_cover, :logo, :maturity, :pdf_url, phases: %i[
                    name description
                  ])
          .tap do |attr|
            if params[:reslug].present?
              attr[:slug] = slug_em(attr[:name])
              if params[:duplicate].present?
                first_duplicate = Handbook.slug_starts_with(attr[:slug]).order(slug: :desc).first
                attr[:slug] = attr[:slug] + generate_offset(first_duplicate).to_s
              end
            end
          end
  end
  helper_method :create_pdf
end
