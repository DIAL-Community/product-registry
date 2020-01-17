class GlossariesController < ApplicationController
  before_action :set_glossary, only: [:show, :edit, :update, :destroy]

  # GET /glossaries
  # GET /glossaries.json
  def index
    if params[:search]
      @glossaries = Glossary.name_contains(params[:search])
                            .where(locale: I18n.locale)
                            .order(:name)
    else
      @glossaries = Glossary.where(locale: I18n.locale)
                            .order(:name)
    end
    authorize @glossaries, :view_allowed?
  end

  # GET /glossaries/1
  # GET /glossaries/1.json
  def show
    authorize @glossary, :view_allowed?
  end

  # GET /glossaries/new
  def new
    authorize Glossary, :mod_allowed?
    @glossary = Glossary.new
  end

  # GET /glossaries/1/edit
  def edit
    authorize @glossary, :mod_allowed?
  end

  # POST /glossaries
  # POST /glossaries.json
  def create
    authorize Glossary, :mod_allowed?
    @glossary = Glossary.new(glossary_params)
    @glossary.locale = I18n.locale

    respond_to do |format|
      if @glossary.save
        format.html { redirect_to @glossary, notice: 'Glossary was successfully created.' }
        format.json { render :show, status: :created, location: @glossary }
      else
        format.html { render :new }
        format.json { render json: @glossary.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /glossaries/1
  # PATCH/PUT /glossaries/1.json
  def update
    authorize @glossary, :mod_allowed?
    @glossary.locale = I18n.locale
    respond_to do |format|
      if @glossary.update(glossary_params)
        format.html { redirect_to @glossary, notice: 'Glossary was successfully updated.' }
        format.json { render :show, status: :ok, location: @glossary }
      else
        format.html { render :edit }
        format.json { render json: @glossary.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /glossaries/1
  # DELETE /glossaries/1.json
  def destroy
    authorize @glossary, :mod_allowed?
    @glossary.destroy
    respond_to do |format|
      format.html { redirect_to glossaries_url, notice: 'Glossary was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def duplicates
    @glossaries = []
    if params[:current].present?
      current_slug = slug_em(params[:current])
      original_slug = slug_em(params[:original])
      if current_slug != original_slug
        @glossaries = Glossary.where(slug: current_slug).to_a
      end
    end
    authorize @glossaries, :view_allowed?
    render json: @glossaries, only: [:name]
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_glossary
    @glossary = Glossary.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def glossary_params
    params
      .require(:glossary)
      .permit(:name, :slug, :locale, :description)
      .tap do |attr|
        if attr[:description].present?
          attr[:description] = JSON.parse(attr[:description])
        end
        if params[:reslug].present?
          attr[:slug] = slug_em(attr[:name])
          if params[:duplicate].present?
            first_duplicate = Glossary.slug_starts_with(attr[:slug]).order(slug: :desc).first
            attr[:slug] = attr[:slug] + generate_offset(first_duplicate).to_s
          end
        end
      end
  end
end
