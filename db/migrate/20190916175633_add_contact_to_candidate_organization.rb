class AddContactToCandidateOrganization < ActiveRecord::Migration[5.1]
  def change
    create_table 'candidate_organizations_contacts', id: false, force: :cascade do |t|
      t.bigint 'candidate_organization_id', null: false
      t.bigint 'contact_id', null: false
      t.datetime 'started_at'
      t.datetime 'ended_at'
      t.index %w[candidate_organization_id contact_id], name: 'index_candidate_contacts_on_candidate_id_and_contact_id'
      t.index %w[contact_id candidate_organization_id], name: 'index_candidate_contacts_on_contact_id_and_candidate_id'
    end
  end
end
