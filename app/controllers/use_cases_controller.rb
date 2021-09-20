class UseCasesController < ApplicationController
  include FilterConcern
  include ApiFilterConcern

  acts_as_token_authentication_handler_for User, only: [:new, :create, :edit, :update, :destroy]

  before_action :set_use_case, only: [:show, :edit, :update, :destroy]
  before_action :set_sectors, only: [:new, :edit, :update, :show]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_current_user, only: [:edit, :update, :destroy]

  def unique_search
    record = UseCase.eager_load(:sdg_targets, :sector, :use_case_descriptions,
                                :use_case_steps, use_case_steps: :use_case_step_descriptions)
                    .find_by(slug: params[:id])
    if record.nil?
      return render(json: {}, status: :not_found)
    end

    render(json: record.to_json(UseCase.serialization_options
                                       .merge({
                                         item_path: request.original_url,
                                         include_relationships: true
                                       })))
  end

  def simple_search
    default_page_size = 20
    use_cases = UseCase

    current_page = 1
    if params[:page].present? && params[:page].to_i > 0
      current_page = params[:page].to_i
    end

    if params[:search].present?
      use_cases = use_cases.name_contains(params[:search])
    end

    use_cases = use_cases.paginate(page: current_page, per_page: default_page_size)

    results = {
      url: request.original_url,
      count: use_cases.count,
      page_size: default_page_size
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if use_cases.count > default_page_size * current_page
      query["page"] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = URI.decode(uri.to_s)
    end

    if current_page > 1
      query["page"] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = URI.decode(uri.to_s)
    end

    results['results'] = use_cases.eager_load(:sdg_targets, :sector, :use_case_descriptions,
                                              :use_case_steps, use_case_steps: :use_case_step_descriptions)
                                  .paginate(page: current_page, per_page: default_page_size)
                                  .order(:slug)

    uri.fragment = uri.query = nil
    render(json: results.to_json(UseCase.serialization_options
                                        .merge({
                                          collection_path: uri.to_s,
                                          include_relationships: true
                                        })))
  end

  def complex_search
    default_page_size = 20
    use_cases = UseCase

    current_page = 1
    if params[:page].present? && params[:page].to_i > 0
      current_page = params[:page].to_i
    end

    if params[:search].present?
      use_cases = use_cases.name_contains(params[:search])
    end

    sdg_use_case_slugs = nil
    if valid_array_parameter(params[:sdgs])
      sdg_use_case_slugs = use_cases_from_sdg_slugs(params[:sdgs])
    end
    if sdg_use_case_slugs.nil? && valid_array_parameter(params[:sustainable_development_goals])
      sdg_use_case_slugs = use_cases_from_sdg_slugs(params[:sustainable_development_goals])
    end

    building_block_product_slugs = nil
    if valid_array_parameter(params[:products])
      building_block_product_slugs = building_blocks_from_product_slugs(params[:products])
    end

    building_block_slugs = nil
    if valid_array_parameter(params[:building_blocks])
      building_block_slugs = params[:building_blocks] if building_block_product_slugs.nil?
      building_block_slugs = building_block_product_slugs & params[:building_blocks] \
        unless building_block_product_slugs.nil?
    else
      building_block_slugs = building_block_product_slugs
    end

    workflow_building_block_slugs = workflows_from_building_block_slugs(building_block_slugs) \
      unless building_block_slugs.nil?

    workflow_slugs = nil
    if valid_array_parameter(params[:workflows])
      workflow_slugs = params[:workflows] if workflow_building_block_slugs.nil?
      workflow_slugs = workflow_building_block_slugs & params[:workflows] \
        unless workflow_building_block_slugs.nil?
    else
      workflow_slugs = workflow_building_block_slugs
    end

    workflow_use_case_slugs = use_cases_from_workflow_slugs(workflow_slugs) \
      unless workflow_slugs.nil?

    use_case_slugs = nil
    if valid_array_parameter(params[:use_cases])
      use_case_slugs = params[:use_cases] if workflow_use_case_slugs.nil?
      use_case_slugs = workflow_use_case_slugs & params[:use_cases] \
        unless workflow_use_case_slugs.nil?
    else
      use_case_slugs = workflow_use_case_slugs
    end

    if use_case_slugs.nil?
      use_case_slugs = sdg_use_case_slugs
    elsif !sdg_use_case_slugs.nil?
      use_case_slugs &= sdg_use_case_slugs
    end

    use_case_slugs = use_case_slugs.reject { |x| x.nil? || x.empty? }
    use_cases = use_cases.where('slug in (?)', use_case_slugs) \
      unless use_case_slugs.nil?

    results = {
      url: request.original_url,
      count: use_cases.count,
      page_size: default_page_size
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if use_cases.count > default_page_size * current_page
      query["page"] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = URI.decode(uri.to_s)
    end

    if current_page > 1
      query["page"] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = URI.decode(uri.to_s)
    end

    results['results'] = use_cases.eager_load(:sdg_targets, :sector, :use_case_descriptions,
                                              :use_case_steps, use_case_steps: :use_case_step_descriptions)
                                  .paginate(page: current_page, per_page: default_page_size)
                                  .order(:slug)

    uri.fragment = uri.query = nil
    render(json: results.to_json(UseCase.serialization_options
                                        .merge({
                                          collection_path: uri.to_s,
                                          include_relationships: true
                                        })))
  end

  def favorite_use_case
    set_use_case
    if current_user.nil? || @use_case.nil?
      return respond_to { |format| format.json { render json: {}, status: :unauthorized } }
    end

    favoriting_user = current_user
    favoriting_user.saved_use_cases.push(@use_case.id)

    respond_to do |format|
      if favoriting_user.save!
        format.json { render :show, status: :ok }
      else
        format.json { render :show, status: :unprocessable_entity }
      end
    end
  end

  def unfavorite_use_case
    set_use_case
    if current_user.nil? || @use_case.nil?
      return respond_to { |format| format.json { render json: {}, status: :unauthorized } }
    end

    favoriting_user = current_user
    favoriting_user.saved_use_cases.delete(@use_case.id)

    respond_to do |format|
      if favoriting_user.save!
        format.json { render :show, status: :ok }
      else
        format.json { render :show, status: :unprocessable_entity }
      end
    end
  end

  # GET /use_cases
  # GET /use_cases.json
  def index
    if params[:without_paging]
      @use_cases = UseCase.name_contains(params[:search])
      authorize @use_cases, :view_allowed?
      return
    end

    @use_cases = filter_use_cases.order(:name)

    if params[:search]
      @use_cases = @use_cases.where('LOWER("use_cases"."name") like LOWER(?)', "%" + params[:search] + "%")
    end

    @use_cases = @use_cases.eager_load(:sdg_targets)
    authorize @use_cases, :view_allowed?
  end

  def count
    @use_cases = filter_use_cases

    authorize @use_cases, :view_allowed?
    render json: @use_cases.count
  end

  def export_data
    @use_cases = UseCase.where(id: filter_use_cases).eager_load(:sdg_targets, :use_case_steps, :use_case_descriptions)
    authorize(@use_cases, :view_allowed?)
    respond_to do |format|
      format.csv do
        render csv: @use_cases, filename: 'exported-use-case'
      end
      format.json do
        render json: @use_cases.to_json(UseCase.serialization_options)
      end
    end
  end

  # GET /use_cases/1
  # GET /use_cases/1.json
  def show
    authorize @use_case, :view_allowed?
  end

  # GET /use_cases/new
  def new
    authorize(UseCase, :create_allowed?)
    @use_case = UseCase.new
    @uc_desc = UseCaseDescription.new
    @ucs_header = UseCaseHeader.new
  end

  # GET /use_cases/1/edit
  def edit
    authorize @use_case, :mod_allowed?
  end

  def duplicates
    @use_cases = Array.new
    if params[:current].present?
      current_slug = slug_em(params[:current]);
      original_slug = slug_em(params[:original]);
      if (current_slug != original_slug)
        @use_cases = UseCase.where(slug: current_slug).to_a
      end
    end
    authorize UseCase, :view_allowed?
    render json: @use_cases, :only => [:name]
  end

  # POST /use_cases
  # POST /use_cases.json
  def create
    authorize(UseCase, :create_allowed?)
    @use_case = UseCase.new(use_case_params)
    @use_case.set_current_user(current_user)
    @uc_desc = UseCaseDescription.new
    @uc_desc.set_current_user(current_user)
    @ucs_header = UseCaseHeader.new

    if (params[:selected_sdg_targets])
      params[:selected_sdg_targets].keys.each do |sdg_target_id|
        sdg_target = SdgTarget.find(sdg_target_id)
        @use_case.sdg_targets.push(sdg_target)
      end
    end

    if policy(@use_case).beta_only?
      if use_case_params[:maturity] != UseCase.entity_status_types[:BETA] &&
          session[:use_case_elevated_role].to_s.downcase != 'true'
        session[:use_case_elevated_role] = true
      end

      # Always override to beta if the user don't have the right role
      @use_case.maturity = UseCase.entity_status_types[:BETA]
    end

    respond_to do |format|
      if @use_case.save
        if use_case_params[:uc_desc].present?
          @uc_desc.use_case_id = @use_case.id
          @uc_desc.locale = I18n.locale
          @uc_desc.description = use_case_params[:uc_desc]
          @uc_desc.save
        end
        if use_case_params[:ucs_header].present?
          @ucs_header.use_case_id = @use_case.id
          @ucs_header.locale = I18n.locale
          @ucs_header.header = use_case_params[:ucs_header]
          @ucs_header.save
        end
        format.html { redirect_to @use_case,
                      flash: { notice: t('messages.model.created', model: t('model.use-case').to_s.humanize) }}
        format.json { render :show, status: :created, location: @use_case }
      else
        format.html { render :new }
        format.json { render json: @use_case.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /use_cases/1
  # PATCH/PUT /use_cases/1.json
  def update
    authorize @use_case, :mod_allowed?

    sdg_targets = Set.new
    if (params[:selected_sdg_targets])
      params[:selected_sdg_targets].keys.each do |sdg_target_id|
        sdg_target = SdgTarget.find(sdg_target_id)
        sdg_targets.add(sdg_target)
      end
    end
    @use_case.sdg_targets = sdg_targets.to_a

    if use_case_params[:uc_desc].present?
      if @uc_desc.locale != I18n.locale.to_s
        @uc_desc = UseCaseDescription.new
      end
      @uc_desc.use_case_id = @use_case.id
      @uc_desc.locale = I18n.locale
      @uc_desc.description = use_case_params[:uc_desc]
      @uc_desc.save
    end

    if policy(@use_case).beta_only?
      if use_case_params[:maturity] != UseCase.entity_status_types[:BETA] &&
          session[:use_case_elevated_role].to_s.downcase != 'true'
        session[:use_case_elevated_role] = true
      end

      # Always override to beta if the user don't have the right role
      @use_case.maturity = UseCase.entity_status_types[:BETA]
    end

    if use_case_params[:ucs_header].present?
      @ucs_header.use_case_id = @use_case.id
      @ucs_header.locale = I18n.locale
      @ucs_header.header = use_case_params[:ucs_header]
      @ucs_header.save
    end

    respond_to do |format|
      if @use_case.update(use_case_params)
        format.html { redirect_to use_case_path(@use_case, locale: session[:locale],
                                  flash: { notice: t('messages.model.updated', model: t('model.use-case').to_s.humanize) })}
        format.json { render :show, status: :ok, location: @use_case }
      else
        format.html { render :edit }
        format.json { render json: @use_case.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /use_cases/1
  # DELETE /use_cases/1.json
  def destroy
    authorize(@use_case, :delete_allowed?)
    @use_case.destroy
    respond_to do |format|
      format.html { redirect_to use_cases_url,
                    flash: { notice: t('messages.model.deleted', model: t('model.use-case').to_s.humanize) }}
      format.json { head :no_content }
    end
  end

  private

    def set_use_case
      if !params[:id].scan(/\D/).empty?
        @use_case = UseCase.find_by(slug: params[:id]) or not_found
      else
        @use_case = UseCase.find_by(id: params[:id]) or not_found
      end
      @sector_name = Sector.find(@use_case.sector_id).name
      @uc_desc = UseCaseDescription.where(use_case_id: @use_case, locale: I18n.locale).first
      @uc_desc ||= UseCaseDescription.where(use_case_id: @use_case, locale: I18n.default_locale).first
      if @uc_desc.nil?
        @uc_desc = UseCaseDescription.new
      end
      @ucs_header = UseCaseHeader.where(use_case_id: @use_case, locale: I18n.locale).first
      if @ucs_header.nil?
        @ucs_header = UseCaseHeader.new
      end
    end

    def set_sectors
      @sectors = Sector.order(:name)
    end

    def set_current_user
      @use_case.set_current_user(current_user)
      @uc_desc.set_current_user(current_user)
    end

  # Never trust parameters from the scary internet, only allow the white list through.
  def use_case_params
    params.require(:use_case)
          .permit(:name, :slug, :sector_id, :uc_desc, :ucs_header, :maturity)
          .tap do |attr|
            valid_tags = []
            if params[:use_case_tags].present?
              valid_tags = params[:use_case_tags].reject(&:empty?).map(&:downcase)
            end
            attr[:tags] = valid_tags

            if params[:reslug].present?
              attr[:slug] = slug_em(attr[:name])
              if params[:duplicate].present?
                first_duplicate = UseCase.slug_starts_with(attr[:slug]).order(slug: :desc).first
                attr[:slug] = attr[:slug] + generate_offset(first_duplicate).to_s
              end
            end
          end
  end
end
