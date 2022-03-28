# frozen_string_literal: true

class MoveUsersProductsToUsers < ActiveRecord::Migration[5.2]
  def up
    User.all.each do |unmigrated_user|
      unmigrated_user.products.each do |product|
        (unmigrated_user.user_products ||= []) << product.id
      end

      unmigrated_user.products.destroy_all

      puts "Migrated user-products information for: #{unmigrated_user.email}." if unmigrated_user.save!
    end
  end

  def down
    User.all.each do |unmigrated_user|
      unmigrated_user.user_products.each do |product_id|
        product = Product.find(product_id)
        unmigrated_user.products << product unless product.nil?
      end

      unmigrated_user.user_products = []

      puts "Migrated user-products information for: #{unmigrated_user.email}." if unmigrated_user.save!
    end
  end
end
