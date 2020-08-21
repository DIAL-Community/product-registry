class AddMappingTypeToProductBuildingBlock < ActiveRecord::Migration[5.2]
  def change
    add_column(:products_building_blocks, :mapping_status, :mapping_status_type, null: false, default: 'BETA')
  end
end
