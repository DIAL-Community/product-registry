# frozen_string_literal: true

module Types
  class CandidateRoleType < Types::BaseObject
    field :id, ID, null: false
    field :email, String, null: false
    field :roles, [String], null: true
    field :description, String, null: true
    field :product_id, String, null: true
    field :organization_id, String, null: true

    field :product, Types::ProductType, null: true, method: :candidate_role_product
    field :organization, Types::OrganizationType, null: true, method: :candidate_role_organization

    field :rejected, Boolean, null: true
  end
end
