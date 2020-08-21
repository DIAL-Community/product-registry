class AddColumnRolesToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column(:users, :roles, :user_role, array: true, default: [])
    change_column_null(:users, :role, true)
  end
end
