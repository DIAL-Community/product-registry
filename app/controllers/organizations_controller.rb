require 'csv'
require 'modules/geocode'

class OrganizationsController < ApplicationController
  include OrganizationsHelper
  include FilterConcern
  include Modules::Geocode

  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_organization, only: [:show, :edit, :update, :destroy]
  before_action :set_current_user, only: [:edit, :update, :destroy]
  before_action :set_core_services, only: [:show, :edit, :update, :new]

  skip_before_action :verify_authenticity_token, only: [:complex_search]

  def map_aggregators_osm
  end

  def map_osm
  end

  def unique_search
    record = Organization.eager_load(:products, :countries, :sectors, :projects, :offices)
                         .find_by(slug: params[:id])
    if record.nil?
      return render(json: {}, status: :not_found)
    end

    render(json: record.as_json(Organization.serialization_options
                                            .merge({
                                              item_path: request.original_url,
                                              include_relationships: true
                                            })))
  end

  def simple_search
    default_page_size = 20
    organizations = Organization

    current_page = 1
    if params[:page].present? && params[:page].to_i > 0
      current_page = params[:page].to_i
    end

    if params[:search].present?
      organizations = organizations.name_contains(params[:search])
    end

    results = {
      url: request.original_url,
      count: organizations.count,
      page_size: default_page_size
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if organizations.count > default_page_size * current_page
      query["page"] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = URI.decode(uri.to_s)
    end

    if current_page > 1
      query["page"] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = URI.decode(uri.to_s)
    end

    results['results'] = organizations.eager_load(:products, :countries, :sectors, :projects, :offices)
                                      .paginate(page: current_page, per_page: default_page_size)
                                      .order(:slug)

    uri.fragment = uri.query = nil
    render(json: results.as_json(Organization.serialization_options
                                             .merge({
                                               collection_path: uri.to_s,
                                               include_relationships: true
                                             })))
  end

  def complex_search
    default_page_size = 20
    organizations = Organization.order(:slug)

    current_page = 1
    if params[:page].present? && params[:page].to_i > 0
      current_page = params[:page].to_i
    end

    if params[:search].present?
      organizations = organizations.name_contains(params[:search])
    end

    if params[:countries].present?
      countries = params[:countries].reject { |x| x.nil? || x.empty? }
      organizations = organizations.joins(:countries)
                                   .where('countries.code in (?)', countries) \
        unless countries.empty?
    end

    if params[:sectors].present?
      sectors = params[:sectors].reject { |x| x.nil? || x.empty? }
      organizations = organizations.joins(:sectors)
                                   .where('sectors.slug in (?)', sectors) \
        unless sectors.empty?
    end

    if params[:endorsing_years].present?
      years = params[:endorsing_years].reject { |x| x.nil? || x.empty? }
      organizations = organizations.where('extract(year from when_endorsed) in (?)', years) \
        unless years.empty?
    end

    results = {
      url: request.original_url,
      count: organizations.count,
      page_size: default_page_size
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if organizations.count > default_page_size * current_page
      query["page"] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = URI.decode(uri.to_s)
    end

    if current_page > 1
      query["page"] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = URI.decode(uri.to_s)
    end

    results['results'] = organizations.eager_load(:products, :countries, :sectors, :projects, :offices)
                                      .paginate(page: current_page, per_page: default_page_size)
                                      .order(:slug)

    uri.fragment = uri.query = nil
    render(json: results.to_json(Organization.serialization_options
                                             .merge({
                                               collection_path: uri.to_s,
                                               include_relationships: true
                                             })))
  end

  # GET /organizations
  # GET /organizations.json
  def index
    if params[:without_paging]
      @organizations = Organization
      !params[:mni_only].nil? && @organizations = @organizations.where('is_mni is true')
      !params[:sector_id].nil? && @organizations = @organizations.joins(:sectors).where('sectors.id = ?', params[:sector_id])
      !params[:search].nil? && @organizations = @organizations.name_contains(params[:search])
      @organizations = @organizations.eager_load(:sectors, :countries, :offices).order(:name)
      authorize @organizations, :view_allowed?
      return
    end

    # :filtered_time will be updated every time we add or remove a filter.
    if session[:filtered_time].to_s.downcase != session[:org_filtered_time].to_s.downcase
      # :org_filtered_time is not updated after the filter is updated:
      # - rebuild the product id cache
      logger.info('Filter updated. Rebuilding cached product id list.')

      org_ids = filter_organizations
      session[:org_filtered_ids] = org_ids
      session[:org_filtered] = true
      session[:org_filtered_time] = session[:filtered_time]
    end

    # Current page information will be stored in the main page div.
    current_page = params[:page] || 1

    @organizations = Organization.order(:slug)
    if session[:org_filtered].to_s.downcase == 'true'
      @organizations = @organizations.where(id: session[:org_filtered_ids])
    end

    if params[:search].present?
      name_orgs = @organizations.name_contains(params[:search])
      desc_orgs = @organizations.joins(:organization_descriptions)
                                .where("LOWER(description) like LOWER(?)", "%#{params[:search]}%")
      @organizations = @organizations.where(id: (name_orgs + desc_orgs).uniq)
    end

    @organizations = @organizations.paginate(page: current_page, per_page: 20)

    authorize @organizations, :view_allowed?
  end

  def count
    # We will use whichever set the product id cache first: this one or the one in index method.
    # This should reduce the need to execute the same operation multiple time.
    if session[:filtered_time].to_s.downcase != session[:org_filtered_time].to_s.downcase
      org_ids, filter_set = filter_organizations
      session[:org_filtered_ids] = org_ids
      session[:org_filtered] = filter_set
      session[:org_filtered_time] = session[:filtered_time]
    end

    organizations = Organization
    if session[:org_filtered].to_s.downcase == 'true'
      organizations = organizations.where(id: session[:org_filtered_ids])
    end

    authorize organizations, :view_allowed?
    render json: organizations.count
  end

  def export
    export_contacts = params[:export_contacts].downcase == 'true'
    send_data(
      export_with_params(export_contacts),
      filename: 'Endorsing Organizations.xls',
      type: 'application/vnd.ms-excel'
    )
  end

  def export_data
    @organizations = Organization.where(id: filter_organizations).eager_load(:countries, :offices, :products)
    authorize(@organizations, :view_allowed?)
    respond_to do |format|
      format.csv do
        render csv: @organizations, filename: 'exported-organization'
      end
      format.json do
        render json: @organizations.to_json(Organization.serialization_options)
      end
    end
  end

  # GET /organizations/1
  # GET /organizations/1.json
  def show
    authorize @organization, :view_allowed?
  end

  # GET /organizations/new
  def new
    authorize Organization, :create_allowed?
    @organization = Organization.new
    @organization_description = OrganizationDescription.new
  end

  # GET /organizations/1/edit
  def edit
    authorize @organization, :mod_allowed?
  end

  # POST /organizations
  # POST /organizations.json
  def create
    authorize Organization, :create_allowed?
    @organization = Organization.new(organization_params)
    @organization.set_current_user(current_user)

    if params[:selected_sectors].present?
      params[:selected_sectors].keys.each do |sector_id|
        @sector = Sector.find(sector_id)
        @organization.sectors.push(@sector)
      end
    end

    if params[:contact].present?
      contact = Contact.new
      contact.name = params[:contact][:name]
      contact.email = params[:contact][:email]
      contact.title = params[:contact][:title]

      contact_slug = slug_em(params[:contact][:name])
      dupe_count = Contact.where(slug: contact_slug).count
      if dupe_count > 0
        first_duplicate = Contact.slug_starts_with(contact_slug).order(slug: :desc).first
        contact.slug = contact_slug + generate_offset(first_duplicate).to_s
      else
        contact.slug = contact_slug
      end

      organization_contact = OrganizationsContact.new
      organization_contact.contact = contact
      organization_contact.started_at = Time.now.utc

      @organization.organizations_contacts << organization_contact
    end

    if params[:selected_countries].present?
      params[:selected_countries].keys.each do |country_id|
        country = Country.find(country_id)
        @organization.countries.push(country)
      end
    end

    if params[:selected_products].present?
      params[:selected_products].keys.each do |product_id|
        product = Product.find(product_id)
        @organization.products.push(product)
      end
    end

    if params[:selected_projects].present?
      params[:selected_projects].keys.each do |project_id|
        project = Project.find(project_id)
        @organization.projects.push(project)
      end
    end

    if params[:office_magickeys].present?
      params[:office_magickeys].keys.each do |office_magickey|
        auth_token = authenticate_user
        geocoded_office = geocode(office_magickey, auth_token)
        geocoded_office.slug = slug_em("#{@organization.name} #{geocoded_office.name}")
        @organization.offices.push(geocoded_office)
      end
    end

    if params[:city_ids].present?
      params[:city_ids].keys.each do |city_id|
        office = create_office_using_city(city_id)
        next if office.nil?

        office.slug = slug_em("#{@organization.name} #{office.name}")
        @organization.offices.push(office)
      end
    end

    if params[:logo].present?
      uploader = LogoUploader.new(@organization, params[:logo].original_filename, current_user)
      begin
        uploader.store!(params[:logo])
      rescue StandardError => e
        @organization.errors.add(:logo, t('errors.messages.extension_whitelist_error'))
      end
      @organization.set_image_changed(params[:logo].original_filename)
    end

    respond_to do |format|
      if @organization.errors.none? && @organization.save

        if organization_params[:organization_description].present?
          @organization_description = OrganizationDescription.new
          @organization_description.organization_id = @organization.id
          @organization_description.locale = I18n.locale
          @organization_description.description = organization_params[:organization_description]
          @organization_description.save
        end

        format.html do
          redirect_to @organization, flash: {
            notice: t('messages.model.created', model: t('model.organization').to_s.humanize)
          }
        end
        format.json { render :show, status: :created, location: @organization }
      else
        error_message = ''
        @organization.errors.each do |_, err|
          error_message = err
        end
        format.html { redirect_to new_organization_url, flash: { error: error_message } }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organizations/1
  # PATCH/PUT /organizations/1.json
  def update
    authorize @organization, :mod_allowed?
    if params[:selected_sectors].present?
      sectors = Set.new
      params[:selected_sectors].keys.each do |sector_id|
        sector = Sector.find(sector_id)
        sectors.add(sector)
      end
      @organization.sectors = sectors.to_a
    end

    if params[:selected_contacts].present?
      @organization.organizations_contacts.each do |organization_contact|
        contact_id = organization_contact.contact.id
        unless params[:selected_contacts].include?(contact_id.to_s)
          organization_contact.update(ended_at: Time.now.utc)
        end
      end

      params[:selected_contacts].each do |selected_contact|
        organization_contact = @organization.organizations_contacts.find_by(contact_id: selected_contact)
        if organization_contact && organization_contact.ended_at.nil?
          next
        end

        organization_contact = OrganizationsContact.new
        organization_contact.contact = Contact.find_by(id: selected_contact)
        organization_contact.started_at = Time.now.utc

        @organization.organizations_contacts << organization_contact
      end
    else
      OrganizationsContact.where(organization_id: @organization.id)
                          .update(ended_at: Time.now.utc)
    end

    countries = Set.new
    if params[:selected_countries].present?
      params[:selected_countries].keys.each do |country_id|
        country = Country.find(country_id)
        countries.add(country)
      end
    end
    @organization.countries = countries.to_a

    products = Set.new
    if params[:selected_products].present?
      params[:selected_products].keys.each do |product_id|
        product = Product.find(product_id)
        products.add(product)
      end
    end
    @organization.products = products.to_a

    projects = Set.new
    if params[:selected_projects].present?
      params[:selected_projects].keys.each do |project_id|
        project = Project.find(project_id)
        projects.add(project)
      end
    end
    @organization.projects = projects.to_a

    offices = Set.new
    if params[:office_ids].present?
      params[:office_ids].keys.each do |office_id|
        office = Office.find(office_id)
        offices.add(office)
      end
    end

    if params[:office_magickeys].present?
      auth_token = authenticate_user
      params[:office_magickeys].keys.each do |office_magickey|
        geocoded_office = geocode(office_magickey, auth_token)
        geocoded_office.slug = slug_em("#{@organization.name} #{geocoded_office.name}")
        offices.add(geocoded_office)
      end
    end

    if params[:city_ids].present?
      params[:city_ids].keys.each do |city_id|
        office = create_office_using_city(city_id)
        next if office.nil?

        office.slug = slug_em("#{@organization.name} #{office.name}")
        offices.add(office)
      end
    end
    @organization.offices = offices.to_a

    if params[:logo].present?
      uploader = LogoUploader.new(@organization, params[:logo].original_filename, current_user)
      begin
        uploader.store!(params[:logo])
      rescue StandardError => e
        @organization.errors.add(:logo, t('errors.messages.extension_whitelist_error'))
      end
      @organization.set_image_changed(params[:logo].original_filename)
    end

    if organization_params[:organization_description].present?
      @organization_description.organization_id = @organization.id
      @organization_description.locale = I18n.locale
      @organization_description.description = organization_params[:organization_description]
      @organization_description.save
    end

    respond_to do |format|
      if @organization.errors.none?
        if organization_params
          @organization.update(organization_params)
        end
        format.html do
          redirect_to @organization, flash: {
            notice: t('messages.model.updated', model: t('model.organization').to_s.humanize)
          }
        end
        format.json { render :show, status: :ok, location: @organization }
      else
        format.html { render :edit }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.json
  def destroy
    authorize @organization, :mod_allowed?

    # delete any projects associated with this org
    @organization.projects.each do |project|
      project.destroy
    end

    users = User.where(organization_id: @organization.id)
    users.each do |user|
      if user.products.empty?
        user.destroy
      else
        user.organization_id = nil
        user.roles = [User.user_roles[:product_user]] if user.roles.include?(User.user_roles[:org_user])
        user.save
      end
    end

    @organization.destroy
    respond_to do |format|
      format.html { redirect_to organizations_url,
                    flash: { notice: t('messages.model.deleted', model: t('model.organization').to_s.humanize) }}
      format.json { head :no_content }
    end
  end

  def map_aggregators
    @organizations = Organization.eager_load(:locations)
    authorize @organizations, :view_allowed?
  end

  def map
    if !session[:org].nil?
      # Check settings
      map_setting_slug = session[:org].downcase+'_map_view'
      default_map = Setting.where(slug: map_setting_slug).first
      if !default_map.nil?
        case default_map.value
        when 'project'
          redirect_to map_projects_osm_path
        when 'aggregator'
          redirect_to map_aggregators_osm_path
        when 'endorser'
          redirect_to map_osm_path
        end
      end
    end

    # If we didn't redirect, load the default map view
    @organizations = Organization.eager_load(:locations)
    authorize @organizations, :view_allowed?
  end

  def map_fs
    @organizations = Organization.eager_load(:locations)
    response.set_header('Content-Security-Policy', 'frame-ancestors digitalprinciples.org')
    authorize @organizations, :view_allowed?
  end

  def duplicates
    @organizations = []
    if params[:current].present?
      current_slug = slug_em(params[:current])
      original_slug = slug_em(params[:original])
      if current_slug != original_slug
        @organizations = Organization.where(slug: current_slug).to_a
      end
    end
    authorize Organization, :view_allowed?
    render json: @organizations, only: [:name]
  end

  def agg_services
    all_services = []
    services_list = AggregatorCapability.select(:service)
                                        .where(aggregator_id: params[:org])
                                        .map(&:service)
                                        .uniq
    services_list.each do |service|
      capability_list = AggregatorCapability.select(:capability)
                                            .where(service: service, aggregator_id: params[:org],
                                                   country_id: params[:country])
                                            .sort_by(&:capability)
                                            .map(&:capability)
                                            .uniq
      all_services.push({ "name" => service, "count" => capability_list.count })
    end
    if services_list.empty?
      set_core_services
      @core_services.each do |service|
        all_services.push({ "name" => service, "count" => 0 })
      end
    end
    render(json: all_services)
  end

  def service_capabilities
    capability_list = AggregatorCapability.select(:capability)
                                          .where(service: params[:service])
                                          .sort_by(&:capability)
                                          .map(&:capability)
                                          .uniq
    operator_list = OperatorService.select(:name, :id)
                                   .where(country_id: params[:country], service: params[:service])
                                   .uniq
    render(json: { "capability_list" => capability_list, "operator_list" => operator_list })
  end

  def agg_capabilities
    operator_services = OperatorService.select(:id, :name)
                                       .where(service: params[:service], country_id: params[:country])
                                       .uniq
    @capabilities = AggregatorCapability.where(aggregator_id: params[:org], service: params[:service])
    capability_list = []
    operator_services.each do |operator|
      curr_capabilities = @capabilities.where(operator_services_id: operator.id)
      if !curr_capabilities.empty?
        agg_cap = curr_capabilities.select(:capability)
                                   .sort_by(&:capability)
                                   .map(&:capability)
                                   .uniq
        capability_list.push({ "name" => operator.name, "id" => operator.id, "capabilities" => agg_cap })
      end
    end
    render(json: capability_list)
  end

  def update_capability
    if params[:checked] == "true"
      country = Country.where(id: params[:country]).first
      agg_capability = AggregatorCapability.new
      agg_capability.aggregator_id = params[:orgId]
      agg_capability.operator_services_id = params[:operator]
      agg_capability.service = params[:service]
      agg_capability.capability = params[:capability].gsub("-", " ")
      agg_capability.country_name = country.name
      agg_capability.country_id = country.id
      agg_capability.save
    else
      agg_capability = AggregatorCapability.where(operator_services_id: params[:operator],
                                                  capability: params[:capability].gsub("-", " "),
                                                  aggregator_id: params[:orgId])
                                           .first
      agg_capability.destroy
    end
    render(json: agg_capability)
  end

  private

    def create_office_using_city(city_id)
      city = City.find(city_id)

      return if city.nil?

      office = Office.new
      office.city = city.name

      city_name = city.name
      region_name = nil
      country_code = nil

      region = Region.find(city.region_id)
      country = nil
      unless region.nil?
        region_name = region.name
        office.region_id = region.id
        country = Country.find(region.country_id)
      end

      unless country.nil?
        country_code = country.code
        office.country_id = country.id
      end

      address = "#{city_name}, #{region_name}, #{country_code}"
      office.name = address

      office.latitude = city.latitude
      office.longitude = city.longitude
      office
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = Organization.find_by(slug: params[:id])
      if @organization.nil? && params[:id].scan(/\D/).empty?
        @organization = Organization.find(params[:id])
      end

      @organization_description = OrganizationDescription.where(organization_id: @organization, locale: I18n.locale)
                                                         .first
      if @organization_description.nil?
        @organization_description = OrganizationDescription.new
      end

      if !@organization.nil? && @organization.is_mni 
        #operator_services_ids = @organization.aggregator_capabilities.all.select(:operator_services_id).map(&:operator_services_id).uniq
        #@operator_services = OperatorService.where('id in (?)', operator_services_ids)
        # Build the list of countries where they work
        #country_list = @operator_services.select(:locations_id).map(&:locations_id).uniq
        #country_list = @organization.aggregator_capabilities.select(:country_name).map(&:country_name).uniq
        #@countries = Location.where('name in (?)', country_list)
        @can_view_mni = policy(@organization).view_capabilities_allowed?
      end
      @owner = User.where("organization_id=?", @organization.id)
    end

    def set_current_user
      @organization.set_current_user(current_user)
    end

  def authenticate_user
    uri = URI.parse(Rails.configuration.geocode["esri"]["auth_uri"])
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path)
    data = { "client_id" => Rails.configuration.geocode["esri"]["client_id"],
             "client_secret" => Rails.configuration.geocode["esri"]["client_secret"],
             "grant_type" => Rails.configuration.geocode["esri"]["grant_type"] }
    request.set_form_data(data)

    response = http.request(request)
    response_json = JSON.parse(response.body)
    response_json["access_token"]
  end

  def geocode(magic_key, auth_token)
    uri_template = Addressable::Template.new("#{Rails.configuration.geocode['esri']['geocode_uri']}{?q*}")
    geocode_uri = uri_template.expand({
      "q" => {
        "SingleLine" => magic_key,
        "magicKey" => magic_key,
        "token" => auth_token,
        "f" => "json",
        "forStorage" => "true"
      }
    })

    uri = URI.parse(geocode_uri)
    response = Net::HTTP.post_form(uri, {})

    location_data = JSON.parse(response.body)
    location_name = location_data["candidates"][0]["address"]
    location_slug = slug_em(location_name)
    location_x = location_data["candidates"][0]["location"]["x"]
    location_y = location_data["candidates"][0]["location"]["y"]

    location = Location.new(name: location_name, slug: location_slug, location_type: :point,
                            points: [ActiveRecord::Point.new(location_y, location_x)])

    google_auth_key = Rails.application.secrets.google_api_key
    convert_location_using_google(location, google_auth_key)
  end

  def convert_location_using_google(location, google_auth_key)
    # Location is a point:
    # * Reverse geocode to normalize the point
    # * Update using reverse geocode values
    # * Update reference to the state & countries

    office_data = {}

    geocode_data = JSON.parse(reverse_geocode_with_google(location, google_auth_key))
    geocode_results = geocode_data['results']
    geocode_results.each do |geocode_result|
      geocode_result['address_components'].each do |address_component|
        if address_component['types'].include?('locality') ||
          address_component['types'].include?('postal_town')
          office_data['city'] = address_component['long_name']
        elsif address_component['types'].include?('administrative_area_level_3')
          office_data['admin_city'] = address_component['long_name']
        elsif address_component['types'].include?('administrative_area_level_2')
          office_data['subregion'] = address_component['long_name']
        elsif address_component['types'].include?('administrative_area_level_1')
          office_data['region'] = address_component['long_name']
        elsif address_component['types'].include?('country')
          office_data['country_code'] = address_component['short_name']
        end
      end
    end

    if office_data['city'].blank?
      office_data['city'] = office_data['admin_city']
    end

    office = Office.new
    country_code = office_data['country_code']
    unless office_data['country_code'].blank?
      country = find_country(country_code, google_auth_key)
      office.country_id = country.id
    end

    region_name = office_data['region']
    unless office_data['region'].blank? || office_data['country_code'].blank?
      region = find_region(region_name, country_code, google_auth_key)
      office.region_id = region.id
    end

    city_name = office_data['city']
    unless office_data['city'].blank? || office_data['region'].blank? || office_data['country_code'].blank?
      city = find_city(city_name, region_name, country_code, google_auth_key)

      office.city = city.name

      office.latitude = city.latitude
      office.longitude = city.longitude
    end

    if office_data['city'].blank? || office_data['region'].blank? || office_data['country_code'].blank?
      office.latitude = location[:points][0].x
      office.longitude = location[:points][0].y
      office.city = "Unknown"
      unless office_data['city'].blank?
        office.city = office_data['city']
      end
    end

    address = "#{city_name}, #{region_name}, #{country_code}"
    office.name = address
    office
  end

    def set_core_services
      @core_services = ['Airtime', 'API', 'HS', 'Mobile-Internet', 'Mobile-Money', 'Ops-Maintenance', 'OTT', 'SLA',
                        'SMS', 'User-Interface', 'USSD', 'Voice']
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organization_params
      permitted_attributes = policy(Organization).permitted_attributes
      unless @organization.nil?
        permitted_attributes = policy(@organization).permitted_attributes
      end

      params
        .require(:organization)
        .permit(permitted_attributes)
        .tap do |attr|
          if attr[:website].present?
            # Handle both:
            # * http:// or https://
            # * (and the typo) http//: or https//:
            attr[:website] = attr[:website].strip
                                           .sub(/^https?\:\/\//i,'')
                                           .sub(/^https?\/\/\:/i,'')
                                           .sub(/\/$/, '')
          end
          if attr[:when_endorsed].present?
            attr[:when_endorsed] = Date.strptime(attr[:when_endorsed], '%m/%d/%Y')
          end
          if permitted_attributes.include?(:aliases)
            valid_aliases = []
            if params[:other_names].present?
              valid_aliases = params[:other_names].reject(&:empty?)
            end
            attr[:aliases] = valid_aliases
          end
          if params[:reslug].present? && permitted_attributes.include?(:slug)
            attr[:slug] = slug_em(attr[:name])
            if params[:duplicate].present?
              first_duplicate = Organization.slug_starts_with(attr[:slug]).order(slug: :desc).first
              attr[:slug] = attr[:slug] + generate_offset(first_duplicate).to_s
            end
          end
        end
    end
end
