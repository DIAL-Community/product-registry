# frozen_string_literal: true

class RubricCategoriesController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :set_rubric_category, only: %i[show edit update destroy]

  # GET /rubric_categories
  # GET /rubric_categories.json
  def index
    if params[:maturity_rubric_id]
      @maturity_rubric = MaturityRubric.find(params[:maturity_rubric_id])
      redirect_to(@maturity_rubric)
    else
      redirect_to(maturity_rubrics_path)
    end
  end

  # GET /rubric_categories/1
  # GET /rubric_categories/1.json
  def show
    authorize @rubric_category, :view_allowed?
  end

  # GET /rubric_categories/new
  def new
    @rubric_category = RubricCategory.new
    if params[:maturity_rubric_id]
      @maturity_rubric = MaturityRubric.find_by(slug: params[:maturity_rubric_id])
      @rubric_category.maturity_rubric = @maturity_rubric
    end
    authorize @rubric_category, :mod_allowed?
  end

  # GET /rubric_categories/1/edit
  def edit
    authorize @rubric_category, :mod_allowed?
  end

  # POST /rubric_categories
  # POST /rubric_categories.json
  def create
    authorize RubricCategory, :mod_allowed?
    @rubric_category = RubricCategory.new(rubric_category_params)
    @rubric_category_desc = RubricCategoryDescription.new

    if params[:maturity_rubric_id]
      @maturity_rubric = MaturityRubric.find(params[:maturity_rubric_id])
      @rubric_category.maturity_rubric = @maturity_rubric
    end

    respond_to do |format|
      if @rubric_category.save
        if rubric_category_params[:rc_desc].present?
          @rubric_category_desc.rubric_category_id = @rubric_category.id
          @rubric_category_desc.locale = I18n.locale
          @rubric_category_desc.description = rubric_category_params[:rc_desc]
          @rubric_category_desc.save
        end
        format.html do
          redirect_to maturity_rubric_rubric_category_path(@rubric_category.maturity_rubric, @rubric_category),
                      notice: t('messages.model.created', model: t('model.rubric-category').to_s.humanize)
        end
        format.json { render :show, status: :created, location: @rubric_category }
      else
        format.html { render :new }
        format.json { render json: @rubric_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rubric_categories/1
  # PATCH/PUT /rubric_categories/1.json
  def update
    authorize @rubric_category, :mod_allowed?
    if rubric_category_params[:rc_desc].present?
      @rubric_category_desc = RubricCategoryDescription.where(rubric_category_id: @rubric_category.id,
                                                              locale: I18n.locale)
                                                       .first || RubricCategoryDescription.new
      @rubric_category_desc.rubric_category_id = @rubric_category.id
      @rubric_category_desc.locale = I18n.locale
      @rubric_category_desc.description = rubric_category_params[:rc_desc]
      @rubric_category_desc.save
    end
    respond_to do |format|
      if @rubric_category.update(rubric_category_params)
        format.html do
          redirect_to maturity_rubric_rubric_category_path(@rubric_category.maturity_rubric, @rubric_category),
                      notice: t('messages.model.updated', model: t('model.rubric-category').to_s.humanize)
        end
        format.json { render :show, status: :ok, location: @rubric_category }
      else
        format.html { render :edit }
        format.json { render json: @rubric_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rubric_categories/1
  # DELETE /rubric_categories/1.json
  def destroy
    authorize @rubric_category, :mod_allowed?
    maturity_rubric = @rubric_category.maturity_rubric
    @rubric_category.destroy
    respond_to do |format|
      format.html do
        redirect_to maturity_rubric,
                    notice: t('messages.model.deleted', model: t('model.rubric-category').to_s.humanize)
      end
      format.json { head :no_content }
    end
  end

  def duplicates
    @rubric_categories = []
    if params[:current].present?
      current_slug = slug_em(params[:current])
      original_slug = slug_em(params[:original])
      if current_slug != original_slug
        @rubric_categories = RubricCategory.where(slug: current_slug)
                                           .to_a
      end
    end
    authorize RubricCategory, :view_allowed?
    render json: @rubric_categories, only: [:name]
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_rubric_category
    @rubric_category = if !params[:id].scan(/\D/).empty?
                         RubricCategory.find_by(slug: params[:id]) || not_found
                       else
                         RubricCategory.find(params[:id]) || not_found
                       end
  end

  # Only allow a list of trusted parameters through.
  def rubric_category_params
    params.require(:rubric_category)
          .permit(:name, :slug, :weight, :maturity_rubric_id, :rc_desc)
          .tap do |attr|
            if params[:reslug].present?
              attr[:slug] = slug_em(attr[:name])
              if params[:duplicate].present?
                first_duplicate = RubricCategory.slug_starts_with(attr[:slug]).order(slug: :desc).first
                attr[:slug] = attr[:slug] + generate_offset(first_duplicate).to_s
              end
            end
          end
  end
end
