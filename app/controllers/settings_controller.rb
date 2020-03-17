# frozen_string_literal: true

# Setting page where user can set the owning organization.
class SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_setting, only: [:edit, :update, :show]

  # GET /settings
  # GET /settings.json
  def index
    @settings = Setting.order(:name)
                       .paginate(page: params[:page], per_page: 20)
    authorize @settings, :view_allowed?
  end

  # GET /settings/1
  # GET /settings/1.json
  def show
    authorize @setting, :view_allowed?
  end

  # GET /settings/1/edit
  def edit
    authorize @setting, :mod_allowed?
  end

  # PATCH/PUT /settings/1
  # PATCH/PUT /settings/1.json
  def update
    authorize @setting, :mod_allowed?
    respond_to do |format|
      if @setting.update(setting_params)
        format.html { redirect_to @setting, notice: 'Setting was successfully updated.' }
        format.json { render :show, status: :ok, location: @setting }
      else
        format.html { render :edit }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /portal_views/new
  def new
    @setting = Setting.new
    authorize @setting, :view_allowed?
  end

  def create
    authorize Setting, :view_allowed?
    puts "PARAMS: " + setting_params.to_s
    @setting = Setting.new(setting_params)
    @setting.slug = slug_em @setting.name

    respond_to do |format|
      if @setting.save
        format.html { redirect_to @setting, notice: 'Portal view was successfully created.' }
        format.json { render :show, status: :created, location: @portal_view }
      else
        format.html { render :new }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_setting
    @setting = Setting.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def setting_params
    params.require(:setting)
          .permit(:name, :description, :value)
  end
end
