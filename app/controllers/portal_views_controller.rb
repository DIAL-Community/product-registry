class PortalViewsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_portal_view, only: [:show, :edit, :update, :destroy]

  # GET /portal_views
  # GET /portal_views.json
  def index
    if params[:search]
      @portal_views = PortalView.where(nil)
                                .name_contains(params[:search])
                                .order(:name)
                                .paginate(page: params[:page], per_page: 20)
    else
      @portal_views = PortalView.order(:name)
                                .paginate(page: params[:page], per_page: 20)
    end
    authorize @portal_views, :view_allowed?
  end

  def select
    return if current_user.nil?

    authorize PortalView, :view_allowed?

    # Default to the first portal object.
    if session[:portal].nil?
      PortalView.all.each do |portal|
        unless (portal.user_roles & current_user.roles).empty?
          @portal_view = portal
          break
        end
      end
    end

    if !params[:id].nil?
      @portal_view = PortalView.find(params[:id])
      if !@portal_view.nil? && (@portal_view.user_roles & current_user.roles).empty?
        @portal_view = nil
      end
    end
    session[:portal] = @portal_view
    render json: { portal_view: @portal_view }
  end

  # GET /portal_views/1
  # GET /portal_views/1.json
  def show

    stylesheet = Stylesheet.where(portal: @portal_view.slug).first
    if stylesheet.nil?
      stylesheet = Stylesheet.new
    end
    @about_page = stylesheet.about_page
    @stylesheet_color = stylesheet.background_color
    @footer = stylesheet.footer_content
    authorize @portal_view, :view_allowed?
  end

  # GET /portal_views/new
  def new
    @portal_view = PortalView.new
    authorize @portal_view, :view_allowed?
  end

  # GET /portal_views/1/edit
  def edit
    stylesheet = Stylesheet.where(portal: @portal_view.slug).first
    if stylesheet.nil?
      stylesheet = Stylesheet.new
    end
    @about_page = stylesheet.about_page
    @stylesheet_color = stylesheet.background_color
    @footer = stylesheet.footer_content
    authorize @portal_view, :view_allowed?
  end

  # POST /portal_views
  # POST /portal_views.json
  def create
    authorize PortalView, :view_allowed?
    @portal_view = PortalView.new(portal_view_params.except(:about_page, :page_footer))

    respond_to do |format|
      if @portal_view.save
        if params[:logo].present?
          uploader = LogoUploader.new(@portal_view, params[:logo].original_filename, current_user)
          begin
            uploader.store!(params[:logo])
          rescue StandardError => e
            @portal_view.errors.add(:logo, t('errors.messages.extension_whitelist_error'))
          end
        end

        if portal_view_params[:about_page].present?
          stylesheet = Stylesheet.new
          stylesheet.portal = @portal_view.slug
          stylesheet.about_page = portal_view_params[:about_page]
          stylesheet.background_color = portal_view_params[:stylesheet_color]
          stylesheet.footer_content = portal_view_params[:page_footer]
          stylesheet.header_logo = @portal_view.slug+".png"
          stylesheet.save
        end
        format.html { redirect_to @portal_view, notice: 'Portal view was successfully created.' }
        format.json { render :show, status: :created, location: @portal_view }
      else
        format.html { render :new }
        format.json { render json: @portal_view.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /portal_views/1
  # PATCH/PUT /portal_views/1.json
  def update
    if params[:logo].present?
      uploader = LogoUploader.new(@portal_view, params[:logo].original_filename, current_user)
      begin
        uploader.store!(params[:logo])
      rescue StandardError => e
        @portal_view.errors.add(:logo, t('errors.messages.extension_whitelist_error'))
      end
    end

    authorize @portal_view, :view_allowed?
    if portal_view_params[:about_page].present?
      stylesheet = Stylesheet.where(portal: @portal_view.slug).first || Stylesheet.new
      if stylesheet.portal.nil?
        stylesheet.portal = slug_em(portal_view_params[:name])
      end
      stylesheet.about_page = portal_view_params[:about_page]
      stylesheet.background_color = params[:stylesheet_color]
      stylesheet.footer_content = portal_view_params[:page_footer]
      stylesheet.header_logo = @portal_view.slug+".png"
      stylesheet.save
    end

    respond_to do |format|
      if @portal_view.update(portal_view_params.except(:about_page, :page_footer))
        # Update the session's portal if we're editing active portal.
        if session[:portal]['id'] == @portal_view.id
          session[:portal] = @portal_view
        end
        format.html { redirect_to @portal_view, notice: 'Portal view was successfully updated.' }
        format.json { render :show, status: :ok, location: @portal_view }
      else
        format.html { render :edit }
        format.json { render json: @portal_view.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /portal_views/1
  # DELETE /portal_views/1.json
  def destroy
    authorize @portal_view, :view_allowed?
    stylesheet = Stylesheet.where(portal: @portal_view.slug).first
    !stylesheet.nil? && stylesheet.destroy
    @portal_view.destroy
    respond_to do |format|
      format.html { redirect_to portal_views_url, notice: 'Portal view was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def duplicates
    @portal_views = []
    if params[:current].present?
      current_slug = slug_em(params[:current])
      original_slug = slug_em(params[:original])
      if current_slug != original_slug
        @portal_views = PortalView.where(slug: current_slug).to_a
      end
    end

    authorize @portal_views, :view_allowed?
    render json: @portal_views, only: [:name]
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_portal_view
    @portal_view = PortalView.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def portal_view_params
    params.require(:portal_view)
          .permit(:name, :description, :subdomain, :top_nav, :filter_nav, :user_roles, :product_view, :organization_view, :about_page, :page_footer)
          .tap do |attr|
            if params[:selected_top_navs].present?
              attr[:top_navs] =
                params[:selected_top_navs].keys
                                          .map { |key| key }
                                          .reject(&:empty?)
            else
              attr[:top_navs] = []
            end
            if params[:selected_filter_navs].present?
              attr[:filter_navs] =
                params[:selected_filter_navs].keys
                                             .map { |key| key }
                                             .reject(&:empty?)
            else
              attr[:filter_navs] = []
            end
            if params[:selected_user_roles].present?
              attr[:user_roles] =
                params[:selected_user_roles].keys
                                            .map { |key| key }
                                            .reject(&:empty?)
            else
              attr[:user_roles] = []
            end
            if params[:selected_organizations].present?
              attr[:organization_views] =
                params[:selected_organizations].keys
                                               .map { |key| key }
                                               .reject(&:empty?)
            else
              attr[:organization_views] = []
            end
            if params[:selected_products].present?
              attr[:product_views] =
                params[:selected_products].keys
                                          .map { |key| key }
                                          .reject(&:empty?)
            else
              attr[:product_views] = []
            end
            if params[:reslug].present?
              attr[:slug] = slug_em(attr[:name])
              if params[:duplicate].present?
                first_duplicate = PortalView.slug_starts_with(attr[:slug]).order(slug: :desc).first
                attr[:slug] = attr[:slug] + generate_offset(first_duplicate).to_s
              end
            end
          end
  end
end
