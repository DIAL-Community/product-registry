class UseCaseStepsController < ApplicationController
  acts_as_token_authentication_handler_for User, only: [:new, :create, :edit, :update, :destroy]
  
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_use_case_step, only: [:show, :edit, :update, :destroy]

  def unique_search
    record = UseCaseStep.find_by(slug: params[:step_id])
    if record.nil?
      return render(json: {}, status: :not_found)
    end

    render(json: record.to_json(UseCaseStep.serialization_options
                                           .merge({
                                             item_path: request.original_url,
                                             include_relationships: true
                                           })))
  end

  def simple_search
    default_page_size = 20
    use_case_steps = UseCase.find_by(slug: params[:id])
                            .use_case_steps

    current_page = 1
    if params[:page].present? && params[:page].to_i > 0
      current_page = params[:page].to_i
    end

    if params[:search].present?
      use_case_steps = use_case_steps.name_contains(params[:search])
    end

    use_case_steps = use_case_steps.paginate(page: current_page, per_page: default_page_size)

    results = {
      url: request.original_url,
      count: use_case_steps.count,
      page_size: default_page_size
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if use_case_steps.count > default_page_size * current_page
      query["page"] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = URI.decode(uri.to_s)
    end

    if current_page > 1
      query["page"] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = URI.decode(uri.to_s)
    end

    results['results'] = use_case_steps

    uri.fragment = uri.query = nil
    render(json: results.to_json(UseCaseStep.serialization_options
                                            .merge({
                                              collection_path: uri.to_s,
                                              include_relationships: true
                                            })))
  end

  def complex_search
    default_page_size = 20
    use_case_steps = UseCase.find_by(slug: params[:id])
                            .use_case_steps

    current_page = 1
    if params[:page].present? && params[:page].to_i > 0
      current_page = params[:page].to_i
    end

    if params[:search].present?
      use_case_steps = use_case_steps.name_contains(params[:search])
    end

    use_case_steps = use_case_steps.paginate(page: current_page, per_page: default_page_size)

    results = {
      url: request.original_url,
      count: use_case_steps.count,
      page_size: default_page_size
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if use_case_steps.count > default_page_size * current_page
      query["page"] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = URI.decode(uri.to_s)
    end

    if current_page > 1
      query["page"] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = URI.decode(uri.to_s)
    end

    results['results'] = use_case_steps

    uri.fragment = uri.query = nil
    render(json: results.to_json(UseCaseStep.serialization_options
                                            .merge({
                                              collection_path: uri.to_s,
                                              include_relationships: true
                                            })))
  end

  # GET /use_case_steps/1
  # GET /use_case_steps/1.json
  def show
  end

  # GET /use_case_steps/new
  def new
    @use_case_step = UseCaseStep.new
    @ucs_desc = UseCaseStepDescription.new
    if params[:use_case_id]
      if !params[:use_case_id].scan(/\D/).empty?
        @use_case = UseCase.find_by(slug: params[:use_case_id])
      else
        @use_case = UseCase.find_by(id: params[:use_case_id])
      end
      if !@use_case.nil?
        @use_case_step.use_case = @use_case
        @use_case_step.use_case_id = @use_case.id
      end
    end
  end

  # GET /use_case_steps/1/edit
  def edit
  end

  # POST /use_case_steps
  # POST /use_case_steps.json
  def create
    @use_case_step = UseCaseStep.new(use_case_step_params)
    @ucs_desc = UseCaseStepDescription.new

    if params[:use_case_id]
      @use_case = UseCase.find(params[:use_case_id])
      @use_case_step.use_case = @use_case
    end

    if params[:selected_workflows].present?
      params[:selected_workflows].keys.each do |workflow_id|
        workflow = Workflow.find(workflow_id)
        @use_case_step.workflows.push(workflow)
      end
    end

    if params[:selected_products].present?
      params[:selected_products].keys.each do |product_id|
        product = Product.find(product_id)
        @use_case_step.products.push(product)
      end
    end

    respond_to do |format|
      if @use_case_step.save
        if use_case_step_params[:ucs_desc]
          @ucs_desc.use_case_step_id = @use_case_step.id
          @ucs_desc.locale = I18n.locale
          @ucs_desc.description = use_case_step_params[:ucs_desc]
          @ucs_desc.save
        end
        format.html { redirect_to use_case_use_case_step_path(@use_case_step.use_case, @use_case_step), notice: 'Use case step was successfully created.' }
        format.json { render :show, status: :created, location: @use_case_step }
      else
        format.html { render :new }
        format.json { render json: @use_case_step.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /use_case_steps/1
  # PATCH/PUT /use_case_steps/1.json
  def update
    if use_case_step_params[:ucs_desc]
      if @ucs_desc.locale != I18n.locale.to_s
        @ucs_desc = UseCaseStepDescription.new
      end
      @ucs_desc.use_case_step_id = @use_case_step.id
      @ucs_desc.locale = I18n.locale
      @ucs_desc.description = use_case_step_params[:ucs_desc]
      @ucs_desc.save
    end

    workflows = Set.new
    if params[:selected_workflows].present?
      params[:selected_workflows].keys.each do |workflow_id|
        workflow = Workflow.find(workflow_id)
        workflows.add(workflow)
      end
    end
    @use_case_step.workflows = workflows.to_a

    products = Set.new
    if params[:selected_products].present?
      params[:selected_products].keys.each do |product_id|
        product = Product.find(product_id)
        products.add(product)
      end
    end
    @use_case_step.products = products.to_a

    respond_to do |format|
      if @use_case_step.update(use_case_step_params)
        format.html { redirect_to use_case_use_case_step_path(@use_case_step.use_case, @use_case_step, locale: session[:locale]), notice: 'Use case step was successfully updated.' }
        format.json { render :show, status: :ok, location: @use_case_step }
      else
        format.html { render :edit }
        format.json { render json: @use_case_step.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /use_case_steps/1
  # DELETE /use_case_steps/1.json
  def destroy
    use_case = @use_case_step.use_case
    # Remove all description records, ignoring the locale.
    @ucs_descs = UseCaseStepDescription.where(use_case_step_id: params[:id])
    @ucs_descs.destroy_all

    @use_case_step.products.clear
    @use_case_step.destroy
    respond_to do |format|
      format.html { redirect_to use_case_path(use_case), notice: 'Use case step was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def duplicates
    @use_case_steps = []
    if params[:current].present?
      current_slug = slug_em(params[:current])
      original_slug = slug_em(params[:original])
      if current_slug != original_slug
        @use_case_steps = UseCaseStep.where(slug: current_slug).to_a
      end
    end
    authorize UseCaseStep, :view_allowed?
    render json: @use_case_steps, only: [:name]
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_use_case_step
    if !params[:id].scan(/\D/).empty?
      @use_case_step = UseCaseStep.find_by(slug: params[:id]) || not_found
    else
      @use_case_step = UseCaseStep.find(params[:id]) || not_found
    end
    @ucs_desc = UseCaseStepDescription.where(use_case_step_id: @use_case_step, locale: I18n.locale).first
    @ucs_desc ||= UseCaseStepDescription.where(use_case_step_id: @use_case_step, locale: I18n.default_locale).first
    if @ucs_desc.nil?
      @ucs_desc = UseCaseStepDescription.new
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def use_case_step_params
    params.require(:use_case_step)
          .permit(:name, :slug, :step_number, :use_case_id, :ucs_desc)
          .tap do |attr|
            if params[:reslug].present?
              attr[:slug] = slug_em(attr[:name])
              if params[:duplicate].present?
                first_duplicate = UseCaseStep.slug_starts_with(attr[:slug]).order(slug: :desc).first
                attr[:slug] = attr[:slug] + generate_offset(first_duplicate).to_s
              end
            end
          end
  end
end
