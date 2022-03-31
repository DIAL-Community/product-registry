# frozen_string_literal: true

class AddOrganizationToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :organization_id, :bigint
    add_foreign_key 'users', 'organizations', name: 'user_organization_fk'
  end
end
