# frozen_string_literal: true

class AddColumnRolesToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :roles, :user_role, array: true
    change_column_null(:users, :role, true)
  end
end
