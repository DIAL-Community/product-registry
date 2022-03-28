# frozen_string_literal: true

class AddUseCaseStepDescriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :use_case_step_descriptions do |t|
      t.references :use_case_step, foreign_key: true
      t.string :locale, null: false
      t.jsonb :description, null: false, default: '{}'
    end
  end
end
