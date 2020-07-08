class CitiesController < ApplicationController
  before_action :set_city, only: [:show, :edit, :update, :destroy]

  # GET /cities
  # GET /cities.json
  def index
    if params[:without_paging]
      @cities = City.order(:name)
      !params[:search].blank? && @cities = @cities.name_contains(params[:search])
      authorize(@cities, :view_allowed?)
      return
    end

    if params[:search]
      @cities = City.where(nil)
                    .name_contains(params[:search])
                    .order(:name)
                    .paginate(page: params[:page], per_page: 20)
    else
      @cities = City.order(:name)
                    .paginate(page: params[:page], per_page: 20)
    end
    authorize(@cities, :view_allowed?)
  end

  # GET /cities/1
  # GET /cities/1.json
  def show
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_city
    @city = City.find_by(slug: params[:id])
  end
end
