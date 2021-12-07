module Types
  class MutationType < Types::BaseObject
    field :create_candidate_product, mutation: Mutations::CreateCandidateProduct
    field :create_candidate_organization, mutation: Mutations::CreateCandidateOrganization

    field :create_product_repository, mutation: Mutations::CreateProductRepository
    field :update_product_repository, mutation: Mutations::UpdateProductRepository
    field :delete_product_repository, mutation: Mutations::DeleteProductRepository
  end
end
