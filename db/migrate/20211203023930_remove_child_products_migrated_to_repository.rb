class RemoveChildProductsMigratedToRepository < ActiveRecord::Migration[5.2]
  def change
    Product.where(is_child: true).each do |child_product|
      puts "Deleting #{child_product.name} ..."
      if child_product.destroy!
        puts "Product: #{child_product.name} deleted."
      end
    end
  end
end
