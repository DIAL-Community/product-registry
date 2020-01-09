class ProductSuitesController < ApplicationController
  before_action :set_product_suite, only: [:show, :edit, :update, :destroy]

  # GET /product_suites
  # GET /product_suites.json
  def index
    @product_suites = ProductSuite.all
    if params[:search]
      @product_suites = ProductSuite.where(nil)
                                    .name_contains(params[:search])
                                    .order(:name)
                                    .paginate(page: params[:page], per_page: 20)
    else
      @product_suites = ProductSuite.order(:name)
                                    .paginate(page: params[:page], per_page: 20)
    end
    authorize @product_suites, :view_allowed?
  end

  # GET /product_suites/1
  # GET /product_suites/1.json
  def show
    authorize @product_suite, :view_allowed?
  end

  # GET /product_suites/new
  def new
    @product_suite = ProductSuite.new
    authorize @product_suite, :mod_allowed?
  end

  # GET /product_suites/1/edit
  def edit
    authorize @product_suite, :mod_allowed?
  end

  # POST /product_suites
  # POST /product_suites.json
  def create
    authorize ProductSuite, :mod_allowed?
    @product_suite = ProductSuite.new(product_suite_params)

    product_versions = Set.new
    if params[:selected_versions].present?
      params[:selected_versions].keys.each do |version_id|
        product_version = ProductVersion.find(version_id)
        product_versions.add(product_version)
      end
    end
    @product_suite.product_versions = product_versions.to_a

    respond_to do |format|
      if @product_suite.save
        format.html { redirect_to @product_suite, notice: 'Product suite was successfully created.' }
        format.json { render :show, status: :created, location: @product_suite }
      else
        format.html { render :new }
        format.json { render json: @product_suite.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /product_suites/1
  # PATCH/PUT /product_suites/1.json
  def update
    authorize @product_suite, :mod_allowed?
    product_versions = Set.new
    if params[:selected_versions].present?
      params[:selected_versions].keys.each do |version_id|
        product_version = ProductVersion.find(version_id)
        product_versions.add(product_version)
      end
    end
    @product_suite.product_versions = product_versions.to_a

    respond_to do |format|
      if @product_suite.update(product_suite_params)
        format.html { redirect_to @product_suite, notice: 'Product suite was successfully updated.' }
        format.json { render :show, status: :ok, location: @product_suite }
      else
        format.html { render :edit }
        format.json { render json: @product_suite.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_suites/1
  # DELETE /product_suites/1.json
  def destroy
    authorize @product_suite, :mod_allowed?
    @product_suite.destroy
    respond_to do |format|
      format.html { redirect_to product_suites_url, notice: 'Product suite was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def duplicates
    @product_suites = []
    if params[:current].present?
      current_slug = slug_em(params[:current])
      original_slug = slug_em(params[:original])
      if current_slug != original_slug
        @product_suites = ProductSuite.where(slug: current_slug).to_a
      end
    end
    authorize @product_suites, :view_allowed?
    render json: @product_suites, only: [:name]
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product_suite
    @product_suite = ProductSuite.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def product_suite_params
    params.require(:product_suite)
          .permit(policy(ProductSuite).permitted_attributes)
          .tap do |attr|
            if params[:reslug].present? && policy(ProductSuite).permitted_attributes.include?(:slug)
              attr[:slug] = slug_em(attr[:name])
              if params[:duplicate].present?
                first_duplicate = ProductSuite.slug_starts_with(attr[:slug]).order(slug: :desc).first
                attr[:slug] = attr[:slug] + generate_offset(first_duplicate).to_s
              end
            end
          end
  end
end
