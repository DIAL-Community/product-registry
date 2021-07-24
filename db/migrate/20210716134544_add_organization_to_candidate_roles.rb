class AddOrganizationToCandidateRoles < ActiveRecord::Migration[5.2]
  def change
    add_column(:candidate_roles, :organization_id, :integer, null: true)
    add_foreign_key(:candidate_roles, :organizations, column: :organization_id, primary_key: 'id')
  end
end
