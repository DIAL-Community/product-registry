# frozen_string_literal: true

class CreateCategoryIndicators < ActiveRecord::Migration[5.2]
  def change
    create_table :category_indicators do |t|
      t.string :name, null: false
      t.string :slug, unique: true, null: false
      t.column :indicator_type, :category_indicator_type
      t.decimal :weight, null: false, default: 0
      t.references :rubric_category, foreign_key: true
      t.string :data_source
      t.string :source_indicator

      t.timestamps
    end
  end
end
