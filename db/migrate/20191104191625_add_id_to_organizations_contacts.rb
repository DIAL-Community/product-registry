# frozen_string_literal: true

class AddIdToOrganizationsContacts < ActiveRecord::Migration[5.1]
  def change
    add_column :organizations_contacts, :id, :primary_key
  end
end
