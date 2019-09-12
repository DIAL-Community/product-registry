class AuditsController < ApplicationController
  def index
    @curr_type = params[:format]
    @audit_list = Audit.where(associated_type: @curr_type).order(:created_at)
  end
end