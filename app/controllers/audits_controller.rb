class AuditsController < ApplicationController
  def index
    @curr_type = params[:type]
    @audit_list = Audit.where(associated_type: @curr_type)
                       .order(created_at: :desc)
                       .paginate(page: params[:page], per_page: 20)
    authorize(@audit_list, :view_allowed?)
  end
end
