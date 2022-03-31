# frozen_string_literal: true

class AddProductToCandidateRoles < ActiveRecord::Migration[5.2]
  def change
    add_column(:candidate_roles, :product_id, :integer, null: true)
    add_foreign_key(:candidate_roles, :products, column: :product_id, primary_key: 'id')
  end
end
