class ProjectsController < ApplicationController
  before_action :authenticate_user!, only: [:destroy]
  before_action :set_project, only: [:show, :destroy]

  def index
    @projects = Project.all.order(:name)
    authorize @projects, :view_allowed?
  end

  def show
    authorize @project, :view_allowed?
  end

  def destroy
    authorize @project, :mod_allowed?
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url,
                    flash: { notice: t('messages.model.deleted', model: t('model.project').to_s.humanize)) }}
      format.json { head :no_content }
    end
  end
  
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    if !params[:id].scan(/\D/).empty?
      @project = Project.find_by(slug: params[:id])
    else
      @project = Project.find(params[:id])
    end
  end
end
