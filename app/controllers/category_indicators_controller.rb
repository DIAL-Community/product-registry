# frozen_string_literal: true

class CategoryIndicatorsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :set_category_indicator, only: %i[show edit update destroy]

  # GET /category_indicators
  # GET /category_indicators.json
  def index
    if params[:rubric_category_id]
      rubric_category = RubricCategory.find(params[:rubric_category_id])
      redirect_to(maturity_rubric_rubric_category_path(rubric_category.maturity_rubric, rubric_category))
    else
      redirect_to(rubric_categories_path)
    end
  end

  # GET /category_indicators/1
  # GET /category_indicators/1.json
  def show
    authorize(@category_indicator, :view_allowed?)
  end

  # GET /category_indicators/new
  def new
    authorize(CategoryIndicator, :mod_allowed?)
    @category_indicator = CategoryIndicator.new
    if params[:rubric_category_id]
      @rubric_category = RubricCategory.find_by(slug: params[:rubric_category_id])
      @category_indicator.rubric_category = @rubric_category
    end
  end

  # GET /category_indicators/1/edit
  def edit
    authorize(@category_indicator, :mod_allowed?)
  end

  # POST /category_indicators
  # POST /category_indicators.json
  def create
    authorize(CategoryIndicator, :mod_allowed?)
    @category_indicator = CategoryIndicator.new(category_indicator_params)
    @category_indicator_desc = CategoryIndicatorDescription.new

    if params[:rubric_category_id]
      @rubric_category = RubricCategory.find(params[:rubric_category_id])
      @category_indicator.rubric_category = @rubric_category
    end

    respond_to do |format|
      if @category_indicator.save
        if category_indicator_params[:ci_desc].present?
          @category_indicator_desc.category_indicator_id = @category_indicator.id
          @category_indicator_desc.locale = I18n.locale
          @category_indicator_desc.description = category_indicator_params[:ci_desc]
          @category_indicator_desc.save
        end
        format.html do
          rubric_category = @category_indicator.rubric_category
          maturity_rubric = rubric_category.maturity_rubric
          redirect_to(maturity_rubric_rubric_category_category_indicator_path(maturity_rubric, rubric_category,
                                                                              @category_indicator),
                      notice: t('messages.model.created', model: t('model.category-indicator').to_s.humanize))
        end
        format.json { render(:show, status: :created, location: @category_indicator) }
      else
        format.html { render(:new) }
        format.json { render(json: @category_indicator.errors, status: :unprocessable_entity) }
      end
    end
  end

  # PATCH/PUT /category_indicators/1
  # PATCH/PUT /category_indicators/1.json
  def update
    authorize(@category_indicator, :mod_allowed?)
    if category_indicator_params[:ci_desc].present?
      @category_indicator_desc = CategoryIndicatorDescription.where(category_indicator_id: @category_indicator.id,
                                                                    locale: I18n.locale)
                                                             .first || CategoryIndicatorDescription.new
      @category_indicator_desc.category_indicator_id = @category_indicator.id
      @category_indicator_desc.locale = I18n.locale
      @category_indicator_desc.description = category_indicator_params[:ci_desc]
      @category_indicator_desc.save
    end
    respond_to do |format|
      if @category_indicator.update(category_indicator_params)
        format.html do
          rubric_category = @category_indicator.rubric_category
          maturity_rubric = rubric_category.maturity_rubric
          redirect_to(maturity_rubric_rubric_category_category_indicator_path(maturity_rubric, rubric_category,
                                                                              @category_indicator),
                      notice: t('messages.model.updated', model: t('model.category-indicator').to_s.humanize))
        end
        format.json { render(:show, status: :ok, location: @category_indicator) }
      else
        format.html { render(:edit) }
        format.json { render(json: @category_indicator.errors, status: :unprocessable_entity) }
      end
    end
  end

  # DELETE /category_indicators/1
  # DELETE /category_indicators/1.json
  def destroy
    authorize(@category_indicator, :mod_allowed?)
    rubric_category = @category_indicator.rubric_category
    @category_indicator.destroy
    respond_to do |format|
      format.html do
        redirect_to(maturity_rubric_rubric_category_path(rubric_category.maturity_rubric, rubric_category),
                    notice: t('messages.model.deleted', model: t('model.category-indicator').to_s.humanize))
      end
      format.json { head(:no_content) }
    end
  end

  def duplicates
    @category_indicators = []
    if params[:current].present?
      current_slug = slug_em(params[:current])
      original_slug = slug_em(params[:original])
      if current_slug != original_slug
        @category_indicators = CategoryIndicator.where(slug: current_slug)
                                                .to_a
      end
    end
    authorize(@category_indicators, :view_allowed?)
    render(json: @category_indicators, only: [:name])
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_category_indicator
    if !params[:id].scan(/\D/).empty?
      @category_indicator = CategoryIndicator.find_by(slug: params[:id]) || not_found
    else
      @category_indicator = CategoryIndicator.find(params[:id]) || not_found
    end
  end

  # Only allow a list of trusted parameters through.
  def category_indicator_params
    params.require(:category_indicator)
          .permit(:name, :slug, :indicator_type, :weight, :data_source, :source_indicator, :ci_desc,
                  :rubric_category_id)
          .tap do |attr|
            if params[:indicator_type].is_a?(String)
              attr[:indicator_type] = CategoryIndicator.category_indicator_types.key(params[:indicator_type].downcase)
            end
            if params[:reslug].present?
              attr[:slug] = slug_em(attr[:name])
              if params[:duplicate].present?
                first_duplicate = CategoryIndicator.slug_starts_with(attr[:slug]).order(slug: :desc).first
                attr[:slug] = attr[:slug] + generate_offset(first_duplicate).to_s
              end
            end
          end
  end
end
