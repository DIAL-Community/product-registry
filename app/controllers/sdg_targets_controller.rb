class SdgTargetsController < ApplicationController
  before_action :set_sdg_target, only: [:show, :edit, :update, :destroy]

  def index
    if params[:without_paging]
      @sdg_targets = SdgTarget
          .name_contains(params[:search])
          .order(:target_number)
      return
    end

    if params[:search]
      @sdg_targets = SdgTarget
          .where(nil)
          .name_contains(params[:search])
          .order(:target_number)
          .paginate(page: params[:page], per_page: 20)
    else
      @sdg_targets = SdgTarget
          .order(:target_number)
          .paginate(page: params[:page], per_page: 20)
    end
  end

  def show
  end

  def destroy
    use_case = UseCase.find(params[:use_case_id]);
    use_case.sdg_targets.delete(params[:id])
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_sdg_target
    @sdg_target = SdgTarget.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def sdg_target_params
    params
      .require(:sdg_target)
      .permit(:name, :confirmation, :description)
      .tap do |attr|
        if (params[:reslug].present?)
          attr[:slug] = slug_em(attr[:name])
          if (params[:duplicate].present?)
            first_duplicate = BuildingBlock.slug_starts_with(attr[:slug]).order(slug: :desc).first
            attr[:slug] = attr[:slug] + "_" + calculate_offset(first_duplicate).to_s
          end
        end
      end
  end
end