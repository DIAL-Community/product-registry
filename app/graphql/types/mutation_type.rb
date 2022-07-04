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

    field :create_spreadsheet_data, mutation: Mutations::CreateSpreadsheetData

    field :create_product_repository, mutation: Mutations::CreateProductRepository
    field :update_product_repository, mutation: Mutations::UpdateProductRepository
    field :delete_product_repository, mutation: Mutations::DeleteProductRepository

    field :create_organization, mutation: Mutations::CreateOrganization
    field :delete_organization, mutation: Mutations::DeleteOrganization

    field :update_organization_country, mutation: Mutations::UpdateOrganizationCountry
    field :update_organization_contacts, mutation: Mutations::UpdateOrganizationContacts
    field :update_organization_products, mutation: Mutations::UpdateOrganizationProducts
    field :update_organization_sectors, mutation: Mutations::UpdateOrganizationSectors
    field :update_organization_projects, mutation: Mutations::UpdateOrganizationProjects

    field :create_product, mutation: Mutations::CreateProduct

    field :update_product_sectors, mutation: Mutations::UpdateProductSectors
    field :update_product_building_blocks, mutation: Mutations::UpdateProductBuildingBlocks
    field :update_product_organizations, mutation: Mutations::UpdateProductOrganizations
    field :update_product_projects, mutation: Mutations::UpdateProductProjects
    field :update_product_tags, mutation: Mutations::UpdateProductTags
    field :update_product_sdgs, mutation: Mutations::UpdateProductSdgs

    field :create_dataset, mutation: Mutations::CreateDataset
    field :update_dataset_countries, mutation: Mutations::UpdateDatasetCountries
    field :update_dataset_organizations, mutation: Mutations::UpdateDatasetOrganizations
    field :update_dataset_sdgs, mutation: Mutations::UpdateDatasetSdgs
    field :update_dataset_sectors, mutation: Mutations::UpdateDatasetSectors
    field :update_dataset_tags, mutation: Mutations::UpdateDatasetTags

    field :create_project, mutation: Mutations::CreateProject

    field :update_project_organizations, mutation: Mutations::UpdateProjectOrganizations
    field :update_project_products, mutation: Mutations::UpdateProjectProducts
    field :update_project_sectors, mutation: Mutations::UpdateProjectSectors
    field :update_project_countries, mutation: Mutations::UpdateProjectCountries
    field :update_project_tags, mutation: Mutations::UpdateProjectTags

    field :create_use_case, mutation: Mutations::CreateUseCase

    field :update_use_case_sdg_targets, mutation: Mutations::UpdateUseCaseSdgTargets
  end
end
