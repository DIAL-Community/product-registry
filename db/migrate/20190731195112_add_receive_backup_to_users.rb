class AddReceiveBackupToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :receive_backup, :boolean, default: false
  end
end
