class AddMappingStatusToProductSectors < ActiveRecord::Migration[5.2]
  def change
    add_column(:product_sectors, :mapping_status, :mapping_status_type, null: false, default: 'BETA')
  end
end
