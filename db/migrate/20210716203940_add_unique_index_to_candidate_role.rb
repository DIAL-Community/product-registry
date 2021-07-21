class AddUniqueIndexToCandidateRole < ActiveRecord::Migration[5.2]
  def change
    add_index(:candidate_roles, [:email, :roles, :organization_id, :product_id], unique: true, name: 'candidate_roles_unique_fields')
  end
end
