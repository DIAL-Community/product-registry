module Types
  class MutationType < Types::BaseObject
    field :create_candidate_product, mutation: Mutations::CreateCandidateProduct
    field :create_candidate_organization, mutation: Mutations::CreateCandidateOrganization
  end
end
