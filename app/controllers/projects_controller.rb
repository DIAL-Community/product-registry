class ProjectsController < ApplicationController
  before_action :authenticate_user!, only: [:destroy]
  before_action :set_project, only: [:show]

  def index
    authorize @projects, :view_allowed?
    @projects = Project.all.order(:name)
  end

  def show
    authorize @project, :view_allowed?
  end

  def destroy
    authorize @project, :mod_allowed?
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, flash: { notice: 'Project was successfully destroyed.' }}
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
