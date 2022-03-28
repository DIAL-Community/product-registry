# frozen_string_literal: true

class ChangeColumnWeightOnProductIndicators < ActiveRecord::Migration[5.2]
  def change
    remove_column :product_indicators, :weight, :decimal, null: false, default: 0
    add_column :product_indicators, :indicator_value, :string, null: false
  end
end
