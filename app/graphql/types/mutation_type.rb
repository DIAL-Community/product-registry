# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_candidate_product, mutation: Mutations::CreateCandidateProduct
    field :create_candidate_organization, mutation: Mutations::CreateCandidateOrganization

    field :create_playbook, mutation: Mutations::CreatePlaybook
    field :auto_save_playbook, mutation: Mutations::CreatePlaybook

    field :create_play, mutation: Mutations::CreatePlay
    field :auto_save_play, mutation: Mutations::CreatePlay
    field :update_play_order, mutation: Mutations::UpdatePlayOrder
    field :duplicate_play, mutation: Mutations::DuplicatePlay

    field :create_move, mutation: Mutations::CreateMove
    field :auto_save_move, mutation: Mutations::CreateMove
    field :update_move_order, mutation: Mutations::UpdateMoveOrder
    field :create_resource, mutation: Mutations::CreateResource

    field :update_user, mutation: Mutations::UpdateUser

    field :create_product_repository, mutation: Mutations::CreateProductRepository
    field :update_product_repository, mutation: Mutations::UpdateProductRepository
    field :delete_product_repository, mutation: Mutations::DeleteProductRepository

    field :create_organization, mutation: Mutations::CreateOrganization

    field :update_organization_country, mutation: Mutations::UpdateOrganizationCountry

    field :update_organization_contacts, mutation: Mutations::UpdateOrganizationContacts
  end
end
