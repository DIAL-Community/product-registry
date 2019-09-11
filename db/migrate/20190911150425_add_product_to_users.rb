class AddProductToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :product_id, :bigint
    add_foreign_key 'users', 'products', name: 'user_product_fk'
  end
end
