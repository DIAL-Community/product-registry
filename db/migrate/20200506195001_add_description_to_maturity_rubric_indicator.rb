# frozen_string_literal: true

class AddDescriptionToMaturityRubricIndicator < ActiveRecord::Migration[5.2]
  def change
    create_table :category_indicator_descriptions do |t|
      t.references :category_indicator, foreign_key: true
      t.string :locale, null: false
      t.jsonb :description, null: false, default: {}
    end
  end
end
