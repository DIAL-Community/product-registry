# frozen_string_literal: true

class AddSlugToProductSectors < ActiveRecord::Migration[5.2]
  def up
    add_column(:product_sectors, :id, :primary_key)
    add_column(:product_sectors, :slug, :string)
    ProductSector.all.each do |ps|
      ps.slug = "#{ps.product.slug}_#{ps.sector.slug}"

      puts "Product sector updated with: #{ps.slug}." if ps.save!
    end
    change_column(:product_sectors, :slug, :string, null: false, unique: true)
  end

  def down
    remove_column(:product_sectors, :slug)
  end
end
