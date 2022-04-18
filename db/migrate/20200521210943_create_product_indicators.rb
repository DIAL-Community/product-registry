# frozen_string_literal: true

class CreateProductIndicators < ActiveRecord::Migration[5.2]
  def change
    create_table(:product_indicators) do |t|
      t.references(:product, foreign_key: true, null: false)
      t.references(:category_indicator, foreign_key: true, null: false)
      t.decimal(:weight, null: false, default: 0)
    end
  end
end
