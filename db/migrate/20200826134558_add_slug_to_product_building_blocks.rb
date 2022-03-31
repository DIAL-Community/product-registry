# frozen_string_literal: true

class AddSlugToProductBuildingBlocks < ActiveRecord::Migration[5.2]
  def up
    add_column(:product_building_blocks, :id, :primary_key)
    add_column(:product_building_blocks, :slug, :string)
    ProductBuildingBlock.all.each do |pb|
      pb.slug = "#{pb.product.slug}_#{pb.building_block.slug}"

      puts "Product building block updated with: #{pb.slug}." if pb.save!
    end
    change_column(:product_building_blocks, :slug, :string, null: false, unique: true)
  end

  def down
    remove_column(:product_building_blocks, :slug)
  end
end
