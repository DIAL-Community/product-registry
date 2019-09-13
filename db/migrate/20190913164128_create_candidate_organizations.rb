class CreateCandidateOrganizations < ActiveRecord::Migration[5.1]
  def change
    create_table :candidate_organizations do |t|
      t.string :name
      t.string :slug
      t.text :website

      t.timestamps
    end
  end
end
