class AddSlugToProductSdgs < ActiveRecord::Migration[5.2]
  def up
    add_column(:product_sustainable_development_goals, :id, :primary_key)
    add_column(:product_sustainable_development_goals, :slug, :string)
    ProductSustainableDevelopmentGoal.all.each do |psdg|
      psdg.slug = "#{psdg.product.slug}_#{psdg.sustainable_development_goal.number}"

      if psdg.save!
        puts "Product SDG updated with: #{psdg.slug}."
      end
    end
    change_column(:product_sustainable_development_goals, :slug, :string, null: false, unique: true)
  end

  def down
    remove_column(:product_sustainable_development_goals, :slug)
  end
end
