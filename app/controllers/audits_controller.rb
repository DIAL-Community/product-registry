# frozen_string_literal: true

class AuditsController < ApplicationController
  def index
    @curr_type = params[:type]
    if @curr_type.nil?
      @audit_list = Audit.order(created_at: :desc)
                         .paginate(page: params[:page], per_page: 20)
    else
      @audit_list = Audit.where(associated_type: @curr_type)
                         .order(created_at: :desc)
                         .paginate(page: params[:page], per_page: 20)
    end
    authorize(@audit_list, :view_allowed?)
  end
end
