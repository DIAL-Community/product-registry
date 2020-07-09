class MaturityRubricsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_maturity_rubric, only: [:show, :edit, :update, :destroy]

  # GET /maturity_rubrics
  # GET /maturity_rubrics.json
  def index
    if params[:without_paging]
      @maturity_rubrics = MaturityRubric.order(:name)
      !params[:search].blank? && @maturity_rubrics = @maturity_rubrics.name_contains(params[:search])
      authorize @maturity_rubrics, :view_allowed?
      return @maturity_rubrics
    end

    current_page = params[:page] || 1

    @maturity_rubric = MaturityRubric.eager_load(:maturity_rubric_descriptions)
    if params[:search]
      @maturity_rubrics = @maturity_rubric.name_contains(params[:search])
                                          .order(:name)
                                          .paginate(page: current_page, per_page: 5)
    else
      @maturity_rubrics = @maturity_rubric.order(:name)
                                          .paginate(page: current_page, per_page: 5)
    end
    authorize @maturity_rubrics, :view_allowed?
  end

  # GET /maturity_rubrics/1
  # GET /maturity_rubrics/1.json
  def show
    authorize @maturity_rubric, :view_allowed?
  end

  # GET /maturity_rubrics/new
  def new
    @maturity_rubric = MaturityRubric.new
    authorize @maturity_rubric, :mod_allowed?
  end

  # GET /maturity_rubrics/1/edit
  def edit
    authorize @maturity_rubric, :mod_allowed?
  end

  # POST /maturity_rubrics
  # POST /maturity_rubrics.json
  def create
    @maturity_rubric = MaturityRubric.new(maturity_rubric_params)
    @maturity_rubric_desc = MaturityRubricDescription.new

    authorize @maturity_rubric, :mod_allowed?

    respond_to do |format|
      if @maturity_rubric.save
        if maturity_rubric_params[:mr_desc].present?
          @maturity_rubric_desc.maturity_rubric_id = @maturity_rubric.id
          @maturity_rubric_desc.locale = I18n.locale
          @maturity_rubric_desc.description = JSON.parse(maturity_rubric_params[:mr_desc])
          @maturity_rubric_desc.save
        end

        format.html do
          redirect_to @maturity_rubric,
                      notice: t('messages.model.created', model: t('model.maturity-rubric').to_s.humanize)
        end
        format.json { render :show, status: :created, location: @maturity_rubric }
      else
        format.html { render :new }
        format.json { render json: @maturity_rubric.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /maturity_rubrics/1
  # PATCH/PUT /maturity_rubrics/1.json
  def update
    authorize @maturity_rubric, :mod_allowed?
    if maturity_rubric_params[:mr_desc].present?
      @maturity_rubric_desc = MaturityRubricDescription.where(maturity_rubric_id: @maturity_rubric.id,
                                                              locale: I18n.locale)
                                                       .first || MaturityRubricDescription.new
      @maturity_rubric_desc.maturity_rubric_id = @maturity_rubric.id
      @maturity_rubric_desc.locale = I18n.locale
      @maturity_rubric_desc.description = JSON.parse(maturity_rubric_params[:mr_desc])
      @maturity_rubric_desc.save
    end
    respond_to do |format|
      if @maturity_rubric.update(maturity_rubric_params)
        format.html do
          redirect_to @maturity_rubric,
                      notice: t('messages.model.updated', model: t('model.maturity-rubric').to_s.humanize)
        end
        format.json { render :show, status: :ok, location: @maturity_rubric }
      else
        format.html { render :edit }
        format.json { render json: @maturity_rubric.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /maturity_rubrics/1
  # DELETE /maturity_rubrics/1.json
  def destroy
    authorize @maturity_rubric, :mod_allowed?
    @maturity_rubric.destroy
    respond_to do |format|
      format.html do
        redirect_to maturity_rubrics_url,
                    notice: t('messages.model.deleted', model: t('model.maturity-rubric').to_s.humanize)
      end
      format.json { head :no_content }
    end
  end

  def duplicates
    @maturity_rubrics = []
    if params[:current].present?
      current_slug = slug_em(params[:current])
      original_slug = slug_em(params[:original])
      if current_slug != original_slug
        @maturity_rubrics = MaturityRubric.where(slug: current_slug)
                                          .to_a
      end
    end
    authorize MaturityRubric, :view_allowed?
    render json: @maturity_rubrics, only: [:name]
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_maturity_rubric
    if !params[:id].scan(/\D/).empty?
      @maturity_rubric = MaturityRubric.find_by(slug: params[:id]) || not_found
    else
      @maturity_rubric = MaturityRubric.find(params[:id]) || not_found
    end
  end

  # Only allow a list of trusted parameters through.
  def maturity_rubric_params
    params.require(:maturity_rubric)
          .permit(:name, :slug, :mr_desc)
          .tap do |attr|
            if params[:reslug].present?
              attr[:slug] = slug_em(attr[:name])
              if params[:duplicate].present?
                first_duplicate = MaturityRubric.slug_starts_with(attr[:slug]).order(slug: :desc).first
                attr[:slug] = attr[:slug] + generate_offset(first_duplicate).to_s
              end
            end
          end
  end
end
