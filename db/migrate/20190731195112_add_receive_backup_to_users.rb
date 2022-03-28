# frozen_string_literal: true

class AddReceiveBackupToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :receive_backup, :boolean, default: false
  end
end
