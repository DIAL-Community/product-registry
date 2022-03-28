# frozen_string_literal: true

class RemoveIndexOrganizationsContactsOnContactIdAndOrganizationId < ActiveRecord::Migration[5.1]
  def change
    remove_index 'organizations_contacts', name: 'index_organizations_contacts_on_contact_id_and_organization_id'
    remove_index 'organizations_contacts', name: 'index_organizations_contacts_on_organization_id_and_contact_id'
  end
end
