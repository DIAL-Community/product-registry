class AddUserProductsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column(:users, :user_products, :bigint, array: true, default: [])
  end
end
