# frozen_string_literal: true

class AddReceiveAdminEmailsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column(:users, :receive_admin_emails, :boolean, default: false)
  end
end
