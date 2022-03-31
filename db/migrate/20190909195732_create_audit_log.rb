# frozen_string_literal: true

class CreateAuditLog < ActiveRecord::Migration[5.1]
  def self.up
    create_table :audits, force: true do |t|
      t.column :associated_id, :string
      t.column :associated_type, :string
      t.column :user_id, :integer
      t.column :user_role, :string
      t.column :username, :string
      t.column :action, :string
      t.column :audit_changes, :jsonb
      t.column :version, :integer, default: 0
      t.column :comment, :string
      t.column :created_at, :datetime
    end

    add_index :audits, %i[action id version], name: 'auditable_index'
    add_index :audits, %i[associated_type associated_id], name: 'associated_index'
    add_index :audits, %i[user_id user_role], name: 'user_index'
    add_index :audits, :created_at
  end

  def self.down
    drop_table :audits
  end
end
