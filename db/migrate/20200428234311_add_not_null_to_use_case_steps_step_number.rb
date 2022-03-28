# frozen_string_literal: true

class AddNotNullToUseCaseStepsStepNumber < ActiveRecord::Migration[5.2]
  def change
    change_column_null :use_case_steps, :step_number, false
  end
end
