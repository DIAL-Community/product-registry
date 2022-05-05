# frozen_string_literal: true
require 'modules/geocode'

class CountriesController < ApplicationController
  include Modules::Geocode

  acts_as_token_authentication_handler_for User, only: %i[index new create edit update destroy]

  before_action :set_country, only: %i[show edit update destroy]

  def unique_search
    record = Country.find_by(slug: params[:id])
    return render(json: {}, status: :not_found) if record.nil?

    render(json: record.as_json(Country.serialization_options
                                       .merge({
                                         item_path: request.original_url,
                                         include_relationships: true
                                       })))
  end

  def simple_search
    default_page_size = 20
    countries = Country.order(:slug)

    current_page = 1
    current_page = params[:page].to_i if params[:page].present? && params[:page].to_i.positive?

    countries = countries.name_contains(params[:search]) if params[:search].present?

    results = {
      url: request.original_url,
      count: countries.count,
      page_size: default_page_size
    }

    uri = URI.parse(request.original_url)
    query = Rack::Utils.parse_query(uri.query)

    if countries.count > default_page_size * current_page
      query['page'] = current_page + 1
      uri.query = Rack::Utils.build_query(query)
      results['next_page'] = URI.decode(uri.to_s)
    end

    if current_page > 1
      query['page'] = current_page - 1
      uri.query = Rack::Utils.build_query(query)
      results['previous_page'] = URI.decode(uri.to_s)
    end

    results['results'] = countries.paginate(page: current_page, per_page: default_page_size)

    uri.fragment = uri.query = nil
    render(json: results.to_json(Country.serialization_options
                                        .merge({
                                          collection_path: uri.to_s,
                                          include_relationships: true
                                        })))
  end

  # GET /countries
  # GET /countries.json
  def index
    if params[:without_paging]
      @countries = Country.order(:name)
      !params[:search].blank? && @countries = @countries.name_contains(params[:search])
      authorize(@countries, :view_allowed?)
      return
    end

    if params[:search]
      @countries = Country.where(nil)
                          .name_contains(params[:search])
                          .order(:name)
                          .paginate(page: params[:page], per_page: 20)
    else
      @countries = Country.order(:name)
                          .paginate(page: params[:page], per_page: 20)
    end
    authorize(@countries, :view_allowed?)
  end

  # GET /countries/1
  # GET /countries/1.json
  def show
  end

  def new
    authorize(Country, :mod_allowed?)
    @country = Country.new
  end

  # GET /country/1/edit
  def edit
    authorize(@country, :mod_allowed?)
    @country = Country.find(params[:country_id]) if params[:country_id]
  end

  # POST /sectors
  # POST /sectors.json
  def create
    authorize(Country, :mod_allowed?)
    @country = Country.new(country_params)
    @country.slug = slug_em(@country.name)

    country_code_or_name = @country.name
    google_auth_key = Rails.application.secrets.google_api_key
    country_data = JSON.parse(geocode_with_google(@country.name, @country.name, google_auth_key))

    country_results = country_data['results']
    country_results.each do |country_result|
      address_key = country_result['types'].reject { |x| x == 'political' }
                                            .first
      country_result['address_components'].each do |address_component|
        next unless address_component['types'].include?(address_key)

        @country.name = address_component['long_name']
        @country.code = address_component['short_name']
        @country.slug = slug_em(@country.code)
        @country.code_longer = ''
      end
      @country.latitude = country_result['geometry']['location']['lat']
      @country.longitude = country_result['geometry']['location']['lng']
    end

    @country.aliases << country_code_or_name

    respond_to do |format|
      if @country.save
        format.html do
          redirect_to(@country,
                      flash: { notice: t('messages.model.created', model: t('model.country').to_s.humanize) })
        end
        format.json { render(:show, status: :created, location: @country) }
      else
        format.html { render(:new) }
        format.json { render(json: @country.errors, status: :unprocessable_entity) }
      end
    end
  end

  # PATCH/PUT /sectors/1
  # PATCH/PUT /sectors/1.json
  def update
    authorize(@country, :mod_allowed?)

    respond_to do |format|
      if @country.update(country_params)
        format.html do
          redirect_to(@country,
                      flash: { notice: t('messages.model.updated', model: t('model.country').to_s.humanize) })
        end
        format.json { render(:show, status: :ok, location: @country) }
      else
        format.html { render(:edit) }
        format.json { render(json: @country.errors, status: :unprocessable_entity) }
      end
    end
  end

  def destroy
    authorize(@country, :mod_allowed?)

    # Remove any aggregator/operator data that reference this country
    capabilities = AggregatorCapability.where(country_id: @country)
    capabilities.each do |capability|
      capability.destroy
    end

    services = OperatorService.where(country_id: @country)
    services.each do |service|
      service.destroy
    end

    projects = ProjectsCountry.where(country_id: @country)
    projects.each do |project|
      project.destroy
    end

    respond_to do |format|
      if @country.destroy
        format.html do
          redirect_to(countries_url,
                      flash: { notice: t('messages.model.deleted', model: t('model.country').to_s.humanize) })
        end
      else
        format.html do
          redirect_to(countries_url,
                      flash: { notice: t('messages.model.delete-failed',
                                         model: t('model.country').to_s.humanize) })
        end
      end
      format.json { head(:no_content) }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_country
    @country = Country.find_by(slug: params[:id])
  end

  def country_params
    params
      .require(:country)
      .permit(:name, :code, :code_longer, :latitude, :longitude)
      .tap do |attr|
        if params[:reslug].present?
          attr[:slug] = slug_em(attr[:name])
          if params[:duplicate].present?
            first_duplicate = Sector.slug_starts_with(attr[:slug]).order(slug: :desc).first
            attr[:slug] = attr[:slug] + generate_offset(first_duplicate).to_s
          end
        end
      end
  end
end
