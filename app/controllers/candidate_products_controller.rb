# frozen_string_literal: true

class CandidateProductsController < ApplicationController
  acts_as_token_authentication_handler_for User,
                                           only: %i[index show edit new create update destroy approve reject]
  skip_before_action :verify_authenticity_token, if: :json_request

  before_action :set_candidate_product, only: %i[show edit update destroy duplicate approve reject]
  before_action :authenticate_user!, only: %i[new create edit update destroy duplicate approve reject]

  def json_request
    request.format.json?
  end

  def approve
    set_candidate_product
    authorize(@candidate_product, :mod_allowed?)

    product = Product.new
    product.name = @candidate_product.name
    product.website = @candidate_product.website

    product.slug = @candidate_product.slug

    duplicates = Product.where(slug: product.slug)
    if duplicates.count.positive?
      first_duplicate = Product.slug_starts_with(product.slug).order(slug: :desc).first
      product.slug = product.slug + generate_offset(first_duplicate).to_s
    end

    respond_to do |format|
      # Don't re-approve approved candidate.
      if (@candidate_product.rejected.nil? || @candidate_product.rejected) &&
         product.save && @candidate_product.update(rejected: false, approved_date: Time.now,
                                                   approved_by_id: current_user.id)
        format.html { redirect_to(product_url(product), notice: 'Candidate promoted to product.') }
        format.json { render(json: { message: 'Candidate product approved.' }, status: :ok) }
      else
        format.html { redirect_to(candidate_products_url, flash: { error: 'Unable to approve candidate.' }) }
        format.json { render(json: { message: 'Candidate approval failed.' }, status: :bad_request) }
      end
    end
  end

  def reject
    set_candidate_product
    authorize(@candidate_product, :mod_allowed?)
    respond_to do |format|
      # Can only approve new submission.
      if @candidate_product.rejected.nil? &&
         @candidate_product.update(rejected: true, rejected_date: Time.now, rejected_by_id: current_user.id)
        format.html { redirect_to(candidate_products_url, notice: 'Candidate declined.') }
        format.json { render(json: { message: 'Candidate product declined.' }, status: :ok) }
      else
        format.html { redirect_to(candidate_products_url, flash: { error: 'Unable to reject candidate.' }) }
        format.json { render(json: { message: 'Declining candidate failed.' }, status: :bad_request) }
      end
    end
  end

  # GET /candidate_products
  # GET /candidate_products.json
  def index
    @candidate_products = CandidateProduct.all
    authorize(@candidate_products, :view_allowed?)
  end

  # GET /candidate_products/1
  # GET /candidate_products/1.json
  def show
    authorize(@candidate_product, :view_allowed?)
  end

  # GET /candidate_products/new
  def new
    @candidate_product = CandidateProduct.new
    authorize(@candidate_product, :create_allowed?)
  end

  # GET /candidate_products/1/edit
  def edit
    authorize(@candidate_product, :mod_allowed?)
  end

  # POST /candidate_products
  # POST /candidate_products.json
  def create
    authorize(CandidateProduct, :create_allowed?)
    @candidate_product = CandidateProduct.new(candidate_product_params)

    respond_to do |format|
      if @candidate_product.save
        format.html { redirect_to @candidate_product, notice: 'Candidate product was successfully created.' }
        format.json { render :show, status: :created, location: @candidate_product }
      else
        format.html { render :new }
        format.json { render json: @candidate_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /candidate_products/1
  # PATCH/PUT /candidate_products/1.json
  def update
    authorize(@candidate_product, :mod_allowed?)
    respond_to do |format|
      if @candidate_product.update(candidate_product_params)
        format.html { redirect_to @candidate_product, notice: 'Candidate product was successfully updated.' }
        format.json { render :show, status: :ok, location: @candidate_product }
      else
        format.html { render :edit }
        format.json { render json: @candidate_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /candidate_products/1
  # DELETE /candidate_products/1.json
  def destroy
    authorize(@candidate_product, :mod_allowed?)
    @candidate_product.destroy
    respond_to do |format|
      format.html { redirect_to candidate_products_url, notice: 'Candidate product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def duplicates
    @candidate_products = []
    if params[:current].present?
      current_slug = slug_em(params[:current])
      original_slug = slug_em(params[:original])
      if current_slug != original_slug
        @candidate_products = CandidateProduct.where(slug: current_slug)
                                              .select(:name, :slug)
                                              .to_a
      end
    end
    authorize(CandidateProduct, :view_allowed?)
    render(json: @candidate_products, only: [:name])
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_candidate_product
    @candidate_product = CandidateProduct.find_by(slug: params[:id])
    @candidate_product = CandidateProduct.find(params[:id]) if @candidate_product.nil? && params[:id].scan(/\D/).empty?
  end

  # Only allow a list of trusted parameters through.
  def candidate_product_params
    params.require(:candidate_product)
          .permit(:name, :website, :repository, :submitter_email)
          .tap do |attr|
            if attr[:website].present?
              attr[:website] = attr[:website].strip
                                             .sub(%r{^https?://}i, '')
                                             .sub(%r{^https?//:}i, '')
                                             .sub(%r{/$}, '')
            end
            if params[:reslug].present?
              attr[:slug] = slug_em(attr[:name])
              if params[:duplicate].present?
                first_duplicate = CandidateProduct.slug_starts_with(attr[:slug])
                                                  .order(slug: :desc).first
                attr[:slug] = attr[:slug] + generate_offset(first_duplicate).to_s
              end
            end
          end
  end
end
