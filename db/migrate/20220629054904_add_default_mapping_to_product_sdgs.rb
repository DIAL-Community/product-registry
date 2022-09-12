# frozen_string_literal: true
class AddDefaultMappingToProductSdgs < ActiveRecord::Migration[5.2]
  def up
    change_column_default(:product_sustainable_development_goals, :mapping_status, 'BETA')
  end

  def down
    change_column_default(:product_sustainable_development_goals, :mapping_status, 'BETA')
  end
end
