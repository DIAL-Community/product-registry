# frozen_string_literal: true

class CreateCandidateOrganizations < ActiveRecord::Migration[5.1]
  def change
    create_table :candidate_organizations do |t|
      t.string :name, null: false
      t.string :slug, unique: true, null: false
      t.text :website

      t.boolean :rejected
      t.datetime :rejected_date
      t.references :rejected_by, index: true, foreign_key: { to_table: :users }
      t.datetime :approved_date
      t.references :approved_by, index: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
