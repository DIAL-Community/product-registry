class AddSlugToProductProductRelationship < ActiveRecord::Migration[5.2]
  def up
    add_column(:product_product_relationships, :slug, :string)
    ProductProductRelationship.all.each do |ppr|
      ppr.slug = "#{ppr.from_product.slug}_#{ppr.to_product.slug}_#{ppr.relationship_type}"

      if ppr.save!
        puts "Product sector updated with: #{ppr.slug}."
      end
    end
    change_column(:product_product_relationships, :slug, :string, null: false, unique: true)
  end

  def down
    remove_column(:product_product_relationships, :slug)
  end
end
