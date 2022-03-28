# frozen_string_literal: true

class ChangeProductsBuildingBlocksToProductBuildingBlocks < ActiveRecord::Migration[5.2]
  def change
    rename_table(:products_building_blocks, :product_building_blocks)
  end
end
