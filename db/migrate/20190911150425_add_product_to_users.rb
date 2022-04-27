# frozen_string_literal: true

class AddProductToUsers < ActiveRecord::Migration[5.1]
  def change
    create_table('users_products', id: false, force: :cascade) do |t|
      t.bigint('user_id', null: false)
      t.bigint('product_id', null: false)
      t.index(%w[user_id product_id], name: 'users_products_idx', unique: true)
      t.index(%w[product_id user_id], name: 'products_users_idx', unique: true)
    end

    add_foreign_key('users_products', 'users', name: 'users_products_user_fk')
    add_foreign_key('users_products', 'products', name: 'users_products_product_fk')
  end
end
