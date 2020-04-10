class OperatorServicesController < ApplicationController
  before_action :set_operator_services, only: [:show, :edit, :update, :destroy]
  before_action :set_core_services

  # GET /operators
  # GET /operators.json
  def index
    if params[:without_paging]
      @operators = OperatorService.order(:name)
      authorize @operators, :map_allowed?
      return
    end

    @operators = OperatorService.select(:name).distinct.order(:name)
    !params[:search].nil? && @operators = @operators.name_contains(params[:search])
    authorize @operators, :view_allowed?
  end

  # GET /organizations/name
  # GET /organizations/name.json
  def show
    authorize OperatorService, :view_allowed?
  end

  # GET /organizations/new
  def new
    authorize OperatorService, :mod_allowed?
    @operator_service = OperatorService.new
  end

  # GET /organizations/name/edit
  def edit
    authorize @operator_services, :mod_allowed?
  end

  # POST /organizations
  # POST /organizations.json
  def create
    authorize OperatorService, :mod_allowed?
    operator_name = params[:operator_service][:name]

    selected_countries = []
    if (params[:selected_countries].present?)
      selected_countries = params[:selected_countries].keys.map(&:to_i)
    end

    selected_countries.each do |country|
      # create records for each core service in this geography
      @core_services.each do |service|
        new_service = OperatorService.new
        new_service.name = operator_name
        new_service.locations_id = country
        new_service.service = service
        new_service.save
      end
    end

    respond_to do |format|
        format.html { redirect_to operator_services_path,
                      flash: { notice: t('messages.model.created', model: t('model.organization').to_s.humanize) }}
        format.json { render :show, status: :created, location: @operator_service }
    end
  end

  # PATCH/PUT /organizations/1
  # PATCH/PUT /organizations/1.json
  def update
    authorize @operator_services, :mod_allowed?

    if (params[:operator_service][:name] != @operator_services.first.name)
      # update the name for all records
      @operator_services.each do |service|
        service.name = params[:operator_service][:name]
        service.save
      end
    end

    selected_countries = []
    if (params[:selected_countries].present?)
      selected_countries = params[:selected_countries].keys.map(&:to_i)
    end

    # Remove any countries from operator services that were removed in the edit
    country_ids = @operator_services.pluck(:locations_id).uniq
    country_ids.each do |country|
      if !selected_countries.include?(country)
        destroy_services = OperatorService.where(name: @operator_services.first.name, locations_id: country).destroy_all
      end
    end

    selected_countries.each do |country|
      if !country_ids.include?(country)
        # create records for each core service in this geography
        @core_services.each do |service|
          new_service = OperatorService.new
          new_service.name = @operator_services.first.name
          new_service.locations_id = country
          new_service.service = service
          new_service.save
        end
      end
    end
  
    respond_to do |format|
        format.html { redirect_to operator_services_path,
                      flash: { notice: t('messages.model.updated', model: t('model.organization').to_s.humanize) }}
        format.json { render :show, status: :ok, location: @operator_services }
    end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.json
  def destroy
    authorize @operator_services, :mod_allowed?

    # Remove all countries from operator services 
    country_ids = @operator_services.pluck(:locations_id).uniq
    country_ids.each do |country|
      destroy_services = OperatorService.where(name: @operator_services.first.name, locations_id: country).destroy_all
    end

    respond_to do |format|
      format.html { redirect_to operator_services_path,
                    flash: { notice: t('messages.model.deleted', model: t('model.operator_services').to_s.humanize) }}
      format.json { head :no_content }
    end
  end

  def map
    #@organizations = Organization.eager_load(:locations)
    #authorize @organizations, :view_allowed?
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_operator_services
      @operator_services = OperatorService.where(name: params[:id])
      @operator_service = @operator_services.first
      @operator_name = @operator_service.name
      @operator_countries = Location.where(id: @operator_services.select('locations_id'))
      @curr_operator = OperatorService.new
      @curr_operator.name = @operator_name
      @curr_operator.country_list = @operator_countries

      # The countries_services list is not currently needed. Keeping the code here in case we 
      #  want to add it later
      # @countries_services = { }
      # @operator_countries.each do |country|
      #   curr_services = @operator_services.where(locations_id: country.id)
      #   service_list = []
      #   curr_services.each do |service|
      #     service_list.push(service.service)
      #   end
      #   @countries_services[country.name] = service_list
      # end
    end

    def set_core_services
      @core_services = ['Airtime', 'API', 'HS', 'Mobile-Internet', 'Mobile-Money', 'Ops-Maintenance', 'OTT', 'SLA', 'SMS', 'User-Interface', 'USSD', 'Voice'];
    end

end
