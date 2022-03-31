# frozen_string_literal: true

module Types
  class CandidateRoleType < Types::BaseObject
    field :id, ID, null: false
    field :product_id, String, null: true
    field :organization_id, String, null: true
  end
end
