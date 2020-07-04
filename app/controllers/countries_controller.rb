class CountriesController < ApplicationController
  before_action :set_country, only: [:show, :edit, :update, :destroy]

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

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_country
    @country = Country.find_by(slug: params[:id])
  end
end
