# frozen_string_literal: true

class CandidateUpdates < ActiveRecord::Migration[5.2]
  def change
    add_column(:candidate_organizations, :description, :string, null: true)

    add_column(:candidate_products, :description, :string, null: true)
  end
end
