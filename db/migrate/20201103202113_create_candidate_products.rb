# frozen_string_literal: true

class CreateCandidateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :candidate_products do |t|
      t.string :slug, null: false
      t.string :name, null: false
      t.string :website, null: false
      t.string :repository, null: false
      t.string :submitter_email, null: false

      t.boolean :rejected
      t.datetime :rejected_date
      t.references :rejected_by, index: true, foreign_key: { to_table: :users }
      t.datetime :approved_date
      t.references :approved_by, index: true, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
