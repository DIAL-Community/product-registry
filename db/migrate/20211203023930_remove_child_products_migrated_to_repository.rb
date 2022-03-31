# frozen_string_literal: true

class RemoveChildProductsMigratedToRepository < ActiveRecord::Migration[5.2]
  def change
    Product.where(is_child: true).each do |child_product|
      puts "Deleting #{child_product.name} ..."
      puts "Product: #{child_product.name} deleted." if child_product.destroy!
    end
  end
end
