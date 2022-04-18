# frozen_string_literal: true

class CreateCandidateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table(:candidate_roles) do |t|
      t.string(:email, null: false)
      t.column(:roles, :user_role, array: true)
      t.string(:description, null: false)

      t.boolean(:rejected)
      t.datetime(:rejected_date)
      t.references(:rejected_by, index: true, foreign_key: { to_table: :users })

      t.datetime(:approved_date)
      t.references(:approved_by, index: true, foreign_key: { to_table: :users })

      t.timestamps
    end
  end
end
