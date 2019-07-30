class ProjectsController < ApplicationController
  before_action :set_project, only: [:show]

  def index
    authorize @projects, :view_allowed?
    @projects = Project
        .order(:name)
  end

  def show
    authorize @project, :view_allowed?
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
