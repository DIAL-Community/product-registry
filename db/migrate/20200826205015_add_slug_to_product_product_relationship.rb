# frozen_string_literal: true

class AddSlugToProductProductRelationship < ActiveRecord::Migration[5.2]
  def up
    add_column(:product_product_relationships, :slug, :string)
    ProductProductRelationship.all.each do |ppr|
      ppr.slug = "#{ppr.from_product.slug}_#{ppr.to_product.slug}_#{ppr.relationship_type}"

      puts "Product sector updated with: #{ppr.slug}." if ppr.save!
    end
    change_column(:product_product_relationships, :slug, :string, null: false, unique: true)
  end

  def down
    remove_column(:product_product_relationships, :slug)
  end
end
