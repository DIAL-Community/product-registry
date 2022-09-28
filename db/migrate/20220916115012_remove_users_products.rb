# frozen_string_literal: true
class RemoveUsersProducts < ActiveRecord::Migration[6.1]
  def change
    drop_table(:users_products)
  end
end
