# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :counts, resolver: Queries::CountsQuery

    field :handbooks, resolver: Queries::HandbooksQuery
    field :handbook, resolver: Queries::HandbookQuery
    field :search_handbook, resolver: Queries::SearchHandbookQuery
    field :page_contents, resolver: Queries::PageContentsQuery
    field :export_page_contents, resolver: Queries::ExportPageContentsQuery

    field :candidate_roles, resolver: Queries::CandidateRolesQuery
    field :candidate_role, resolver: Queries::CandidateRoleQuery

    field :products, resolver: Queries::ProductsQuery
    field :product, resolver: Queries::ProductQuery
    field :search_products, resolver: Queries::SearchProductsQuery
    field :paginated_products, resolver: Queries::PaginatedProductsQuery

    field :product_repositories, resolver: Queries::ProductRepositoriesQuery
    field :product_repository, resolver: Queries::ProductRepositoryQuery

    field :endorsers, resolver: Queries::EndorsersQuery

    field :projects, resolver: Queries::ProjectsQuery
    field :project, resolver: Queries::ProjectQuery
    field :search_projects, resolver: Queries::SearchProjectsQuery
    field :paginated_projects, resolver: Queries::PaginatedProjectsQuery

    field :building_blocks, resolver: Queries::BuildingBlocksQuery
    field :building_block, resolver: Queries::BuildingBlockQuery
    field :search_building_blocks, resolver: Queries::SearchBuildingBlocksQuery

    field :sectors, resolver: Queries::SectorsQuery
    field :sectorsWithSubs, resolver: Queries::SectorsWithSubsQuery
    field :search_sectors, resolver: Queries::SearchSectorsQuery

    field :origins, resolver: Queries::OriginsQuery
    field :search_origins, resolver: Queries::SearchOriginsQuery

    field :use_cases, resolver: Queries::UseCasesQuery
    field :use_case, resolver: Queries::UseCaseQuery
    field :search_use_cases, resolver: Queries::SearchUseCasesQuery

    field :use_case_steps, resolver: Queries::UseCaseStepsQuery
    field :use_case_step, resolver: Queries::UseCaseStepQuery

    field :users, resolver: Queries::UsersQuery
    field :user, resolver: Queries::UserQuery
    field :search_users, resolver: Queries::SearchUsersQuery

    field :countries, resolver: Queries::CountriesQuery
    field :search_countries, resolver: Queries::SearchCountriesQuery

    field :organizations, resolver: Queries::OrganizationsQuery
    field :organization, resolver: Queries::OrganizationQuery
    field :search_organizations, resolver: Queries::SearchOrganizationsQuery

    field :aggregators, resolver: Queries::AggregatorsQuery
    field :aggregator, resolver: Queries::AggregatorQuery
    field :search_aggregators, resolver: Queries::SearchAggregatorsQuery
    field :paginated_aggregators, resolver: Queries::PaginatedAggregatorsQuery

    field :capabilities, resolver: Queries::CapabilitiesQuery
    field :operator_services, resolver: Queries::OperatorServicesQuery
    field :capability_only, resolver: Queries::CapabilityOnlyQuery
    field :operator_service_only, resolver: Queries::OperatorServiceOnlyQuery

    field :sdgs, resolver: Queries::SustainableDevelopmentGoalsQuery
    field :sdg, resolver: Queries::SustainableDevelopmentGoalQuery
    field :search_sdgs, resolver: Queries::SearchSustainableDevelopmentGoalsQuery

    field :tags, resolver: Queries::TagsQuery

    field :wizard, resolver: Queries::WizardQuery

    field :workflows, resolver: Queries::WorkflowsQuery
    field :workflow, resolver: Queries::WorkflowQuery
    field :search_workflows, resolver: Queries::SearchWorkflowsQuery

    field :candidate_products, resolver: Queries::CandidateProductsQuery
    field :candidate_product, resolver: Queries::CandidateProductQuery
    field :search_candidate_products, resolver: Queries::SearchCandidateProductsQuery

    field :candidate_organizations, resolver: Queries::CandidateOrganizationsQuery
    field :candidate_organization, resolver: Queries::CandidateOrganizationQuery
    field :search_candidate_organizations, resolver: Queries::SearchCandidateOrganizationsQuery

    field :playbooks, resolver: Queries::PlaybooksQuery
    field :playbook, resolver: Queries::PlaybookQuery
    field :search_playbooks, resolver: Queries::SearchPlaybooksQuery

    field :plays, resolver: Queries::PlaysQuery
    field :play, resolver: Queries::PlayQuery
    field :search_plays, resolver: Queries::SearchPlaysQuery
    field :search_playbook_plays, resolver: Queries::SearchPlaybookPlaysQuery
    field :move, resolver: Queries::MoveQuery

    field :me, resolver: Queries::MeQuery
  end
end
