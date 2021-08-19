module Queries
  class CandidateRolesQuery < Queries::BaseQuery
    argument :product_id, String, required: true
    argument :organization_id, String, required: true
    type [Types::CandidateRoleType], null: false

    def resolve(product_id:, organization_id:)
      candidate_roles = CandidateRole
      unless product_id.nil?
        candidate_roles = candidate_roles.where(product_id: product_id)
      end

      unless organization_id.nil?
        candidate_roles = candidate_roles.where(organization_id: organization_id)
      end
      candidate_roles
    end
  end

  class CandidateRoleQuery < Queries::BaseQuery
    argument :product_id, String, required: true
    argument :organization_id, String, required: true
    argument :email, String, required: true
    type Types::CandidateRoleType, null: false

    def resolve(product_id:, organization_id:, email:)
      candidate_roles = CandidateRole
      if !product_id.nil? && !product_id.blank?
        candidate_roles = candidate_roles.where(product_id: product_id.to_i)
      end

      if !organization_id.nil? && !organization_id.blank?
        candidate_roles = candidate_roles.where(organization_id: organization_id.to_i)
      end

      unless email.nil?
        candidate_roles = candidate_roles.where(email: email)
      end
      candidate_role = candidate_roles.first
      candidate_role
    end
  end
end
