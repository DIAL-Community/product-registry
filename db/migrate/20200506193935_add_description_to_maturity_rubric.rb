# frozen_string_literal: true

class AddDescriptionToMaturityRubric < ActiveRecord::Migration[5.2]
  def change
    create_table(:maturity_rubric_descriptions) do |t|
      t.references(:maturity_rubric, foreign_key: true)
      t.string(:locale, null: false)
      t.jsonb(:description, null: false, default: {})
    end
  end
end
