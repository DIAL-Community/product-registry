# frozen_string_literal: true

class ChangeScriptNameField < ActiveRecord::Migration[5.2]
  def change
    remove_column(:product_indicators, :script_name, :string)
    add_column(:category_indicators, :script_name, :string)
  end
end
