# frozen_string_literal: true

class AddBuildingBlocks < ActiveRecord::Migration[5.1]
  def change
    create_table(:building_blocks) do |t|
      t.string(:name)
      t.string(:slug)

      t.timestamps
    end
    create_table('products_building_blocks', id: false, force: :cascade) do |t|
      t.bigint('building_block_id', null: false)
      t.bigint('product_id', null: false)
      t.index(%w[product_id building_block_id], name: 'prod_blocks')
      t.index(%w[building_block_id product_id], name: 'block_prods')
    end
  end
end
