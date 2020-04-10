class UseCaseStepsController < ApplicationController
  before_action :set_use_case_step, only: [:show, :edit, :update, :destroy]

  # GET /use_case_steps
  # GET /use_case_steps.json
  def index
    @use_case_steps = UseCaseStep.all
  end

  # GET /use_case_steps/1
  # GET /use_case_steps/1.json
  def show
  end

  # GET /use_case_steps/new
  def new
    @use_case_step = UseCaseStep.new
  end

  # GET /use_case_steps/1/edit
  def edit
  end

  # POST /use_case_steps
  # POST /use_case_steps.json
  def create
    @use_case_step = UseCaseStep.new(use_case_step_params)

    respond_to do |format|
      if @use_case_step.save
        format.html { redirect_to @use_case_step, notice: 'Use case step was successfully created.' }
        format.json { render :show, status: :created, location: @use_case_step }
      else
        format.html { render :new }
        format.json { render json: @use_case_step.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /use_case_steps/1
  # PATCH/PUT /use_case_steps/1.json
  def update
    respond_to do |format|
      if @use_case_step.update(use_case_step_params)
        format.html { redirect_to @use_case_step, notice: 'Use case step was successfully updated.' }
        format.json { render :show, status: :ok, location: @use_case_step }
      else
        format.html { render :edit }
        format.json { render json: @use_case_step.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /use_case_steps/1
  # DELETE /use_case_steps/1.json
  def destroy
    @use_case_step.destroy
    respond_to do |format|
      format.html { redirect_to use_case_steps_url, notice: 'Use case step was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_use_case_step
      @use_case_step = UseCaseStep.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def use_case_step_params
      params.require(:use_case_step).permit(:name, :slug, :step_number, :use_case_id)
    end
end
