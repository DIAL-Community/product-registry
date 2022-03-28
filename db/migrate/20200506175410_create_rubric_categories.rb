# frozen_string_literal: true

class CreateRubricCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :rubric_categories do |t|
      t.string :name, null: false
      t.string :slug, unique: true, null: false
      t.decimal :weight, null: false, default: 0
      t.references :maturity_rubric, foreign_key: true

      t.timestamps
    end
  end
end
