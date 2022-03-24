module Types
  class MutationType < Types::BaseObject
    field :create_candidate_product, mutation: Mutations::CreateCandidateProduct
    field :create_candidate_organization, mutation: Mutations::CreateCandidateOrganization

    field :create_playbook, mutation: Mutations::CreatePlaybook

    field :create_play, mutation: Mutations::CreatePlay
    field :update_play_order, mutation: Mutations::UpdatePlay
    field :duplicate_play, mutation: Mutations::DuplicatePlay

    field :create_move, mutation: Mutations::CreateMove

    field :update_user, mutation: Mutations::UpdateUser

    field :create_product_repository, mutation: Mutations::CreateProductRepository
    field :update_product_repository, mutation: Mutations::UpdateProductRepository
    field :delete_product_repository, mutation: Mutations::DeleteProductRepository
  end
end
