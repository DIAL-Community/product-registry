class OrganizationsController < ApplicationController
  include OrganizationsHelper

  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_organization, only: [:show, :edit, :update, :destroy]
  before_action :set_current_user, only: [:edit, :update, :destroy]
  before_action :set_core_services, only: [:show, :edit, :update, :new]

  # GET /organizations
  # GET /organizations.json
  def index
    if params[:without_paging]
      @organizations = Organization
      !params[:mni_only].nil? && @organizations = @organizations.where('is_mni is true') 
      !params[:sector_id].nil? && @organizations = @organizations.joins(:sectors).where('sectors.id = ?', params[:sector_id])
      !params[:search].nil? && @organizations = @organizations.name_contains(params[:search])
      @organizations = @organizations.eager_load(:sectors, :locations).order(:name)
      authorize @organizations, :view_allowed?
      return
    end

    @organizations = search_organizations
    params[:search].present? && @organizations = @organizations.name_contains(params[:search])
    authorize @organizations, :view_allowed?
  end

  def count
    organizations = search_organizations
    authorize organizations, :view_allowed?
    render json: organizations.count
  end

  def search_organizations
    organizations = Organization.all.order(:slug)

    endorser_only = sanitize_session_value 'endorser_only'
    aggregator_only = sanitize_session_value 'aggregator_only'
    countries = sanitize_session_values 'countries'
    products = sanitize_session_values 'products'
    sectors = sanitize_session_values 'sectors'
    years = sanitize_session_values 'years'

    if (endorser_only && aggregator_only)
      organizations = organizations.where(is_endorser: true).or(organizations.where(is_mni: true))
    else
      endorser_only && organizations = organizations.where(is_endorser: true)
      aggregator_only && organizations = organizations.where(is_mni: true)
    end
    !countries.empty? && organizations = organizations.joins(:locations).where('locations.id in (?)', countries)
    !products.empty? && organizations = organizations.joins(:products).where('products.id in (?)', products)
    !sectors.empty? && organizations = organizations.joins(:sectors).where('sectors.id in (?)', sectors)
    !years.empty? && organizations = organizations.where('extract(year from when_endorsed) in (?)', years)
    organizations
  end

  def export
    export_contacts = params[:export_contacts].downcase == "true" ? true : false
    send_data(
      export_with_params(export_contacts),
      filename: "Endorsing Organizations.xls",
      type: "application/vnd.ms-excel"
    )
  end

  # GET /organizations/1
  # GET /organizations/1.json
  def show
    authorize @organization, :view_allowed?
  end

  # GET /organizations/new
  def new
    authorize Organization, :mod_allowed?
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
    authorize Organization, :mod_allowed?
    @organization = Organization.new(organization_params)
    @organization.set_current_user(current_user)

    if (params[:selected_sectors].present?)
      params[:selected_sectors].keys.each do |sector_id|
        @sector = Sector.find(sector_id)
        @organization.sectors.push(@sector)
      end
    end

    if (params[:contact].present?)
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

    if (params[:selected_countries].present?)
      params[:selected_countries].keys.each do |location_id|
        location = Location.find(location_id)
        @organization.locations.push(location)
      end
    end

    if (params[:selected_products].present?)
      params[:selected_products].keys.each do |product_id|
        product = Product.find(product_id)
        @organization.products.push(product)
      end
    end

    if (params[:office_id].present?)
      office = Location.find(params[:office_id])
      if (office)
        @organization.locations.push(office)
      end
    end

    if (params[:office_magickey].present?)
      auth_token = authenticate_user
      geocoded_location = geocode(params[:office_magickey], auth_token)
      geocoded_location.save
      @organization.locations.push(geocoded_location)
    end

    if (params[:logo].present?)
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
          @organization_description.description = JSON.parse(organization_params[:organization_description])
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
    if (params[:selected_sectors].present?)
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

      organization_contacts = []
      params[:selected_contacts].each do |selected_contact|
        organization_contact = @organization.organizations_contacts.find_by(contact_id: selected_contact)
        if organization_contact && organization_contact.ended_at.nil?
          next
        end

        organization_contact = OrganizationsContact.new
        organization_contact.contact = Contact.find(selected_contact)
        organization_contact.started_at = Time.now.utc
        organization_contacts.push(organization_contact)
      end

      @organization.organizations_contacts << organization_contacts
    else
      OrganizationsContact.where(organization_id: @organization.id)
                          .update(ended_at: Time.now.utc)
    end

    locations = Set.new
    if (params[:selected_countries].present?)
      params[:selected_countries].keys.each do |location_id|
        location = Location.find(location_id)
        locations.add(location)
      end
    end

    products = Set.new
    if (params[:selected_products].present?)
      params[:selected_products].keys.each do |product_id|
        product = Product.find(product_id)
        products.add(product)
      end
    end
    @organization.products = products.to_a

    if (params[:office_ids].present?)
      params[:office_ids].keys.each do |office_id|
        office = Location.find(office_id)
        locations.add(office)
      end
    end

    if (params[:office_magickeys].present?)
      auth_token = authenticate_user
      params[:office_magickeys].keys.each do |office_magickey|
        geocoded_location = geocode(office_magickey, auth_token)
        locations.add(geocoded_location)
      end
    end

    @organization.locations = locations.to_a

    if (params[:logo].present?)
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
      @organization_description.description = JSON.parse(organization_params[:organization_description])
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
        user.role == User.roles[:org_product_user] && user.role = User.roles[:product_user]
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
    @organizations = Organization.eager_load(:locations)
    authorize @organizations, :view_allowed?
  end

  def map_fs
    @organizations = Organization.eager_load(:locations)
    response.set_header('Content-Security-Policy', 'frame-ancestors digitalprinciples.org')
    authorize @organizations, :view_allowed?
  end

  def duplicates
    @organizations = Array.new
    if params[:current].present?
      current_slug = slug_em(params[:current]);
      original_slug = slug_em(params[:original]);
      if (current_slug != original_slug)
        @organizations = Organization.where(slug: current_slug).to_a
      end
    end
    authorize @organizations, :view_allowed?
    render json: @organizations, :only => [:name]
  end

  def agg_services
    all_services = []
    country_name = Location.select(:name).where(id: params[:country]).map(&:name).uniq
    services_list = AggregatorCapability.select(:service).where(aggregator_id: params[:org]).map(&:service).uniq
    services_list.each do |service|
      capability_list = AggregatorCapability.select(:capability).where(service: service, aggregator_id: params[:org], country_name: country_name).sort_by(&:capability).map(&:capability).uniq
      all_services.push({ "name" => service, "count" => capability_list.count})
    end
    if (services_list.empty?)
      set_core_services
      @core_services.each do |service|
        all_services.push({ "name" => service, "count" => 0})
      end
    end
    render json: all_services
  end

  def service_capabilities
    capability_list = AggregatorCapability.select(:capability).where(service: params[:service]).sort_by(&:capability).map(&:capability).uniq
    operator_list = OperatorService.select(:name, :id).where(locations_id: params[:country], service: params[:service]).uniq
    render json: { "capability_list" => capability_list, "operator_list" => operator_list }
  end

  def agg_capabilities
    operator_services = OperatorService.select(:id, :name).where(service: params[:service], locations_id: params[:country]).uniq
    @capabilities = AggregatorCapability.where(aggregator_id: params[:org], service: params[:service], operator_services_id: operator_services)
    capability_list = []
    operator_services.each do |operator|
      curr_capabilities = @capabilities.where(operator_services_id: operator.id)
      if (!curr_capabilities.empty?) then
        agg_cap = curr_capabilities.select(:capability).sort_by(&:capability).map(&:capability).uniq
        capability_list.push({ "name" => operator.name, "id" => operator.id, "capabilities" => agg_cap })
      end
    end
    render json: capability_list
  end

  def update_capability
    operator_service = OperatorService.where(id: params[:operator]).first
    puts params[:checked].to_s
    if (params[:checked] == "true")
      country = Location.where(id: params[:country]).first
      agg_capability = AggregatorCapability.new
      agg_capability.aggregator_id = params[:orgId]
      agg_capability.operator_services_id = params[:operator]
      agg_capability.service = params[:service]
      agg_capability.capability = params[:capability].gsub("-"," ")
      agg_capability.country_name = country.name
      agg_capability.save
    else
      agg_capability = AggregatorCapability.where(operator_services_id: params[:operator], capability: params[:capability].gsub("-"," "), aggregator_id: params[:orgId]).first
      agg_capability.destroy
    end
    render json: agg_capability
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = Organization.find_by(slug: params[:id]) or not_found
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
    end

    def set_current_user
      @organization.set_current_user(current_user)
    end

    def authenticate_user
      uri = URI.parse(Rails.configuration.geocode["esri"]["auth_uri"])
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(uri.path)
      data = {"client_id" => Rails.configuration.geocode["esri"]["client_id"],
          "client_secret" => Rails.configuration.geocode["esri"]["client_secret"],
          "grant_type" => Rails.configuration.geocode["esri"]["grant_type"]}
      request.set_form_data(data);

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

      Location.new(name: location_name, slug: location_slug, :location_type => :point,
          points: [ActiveRecord::Point.new(location_y, location_x)])
    end

    def set_core_services
      @core_services = ['Airtime', 'API', 'HS', 'Mobile-Internet', 'Mobile-Money', 'Ops-Maintenance', 'OTT', 'SLA', 'SMS', 'User-Interface', 'USSD', 'Voice'];
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organization_params
      params
        .require(:organization)
        .permit(policy(Organization).permitted_attributes)
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
          if params[:reslug].present? && policy(Organization).permitted_attributes.include?(:slug)
            attr[:slug] = slug_em(attr[:name])
            if params[:duplicate].present?
              first_duplicate = Organization.slug_starts_with(attr[:slug]).order(slug: :desc).first
              attr[:slug] = attr[:slug] + generate_offset(first_duplicate).to_s
            end
          end
        end
    end
end
