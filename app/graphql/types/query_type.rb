module Types
  class QueryType < Types::BaseObject
    field :counts, resolver: Queries::CountsQuery

    field :playbooks, resolver: Queries::PlaybooksQuery
    field :playbook, resolver: Queries::PlaybookQuery
    field :search_playbook, resolver: Queries::SearchPlaybookQuery
    field :page_contents, resolver: Queries::PageContentsQuery
    field :export_page_contents, resolver: Queries::ExportPageContentsQuery

    field :candidate_roles, resolver: Queries::CandidateRolesQuery
    field :candidate_role, resolver: Queries::CandidateRoleQuery

    field :products, resolver: Queries::ProductsQuery
    field :product, resolver: Queries::ProductQuery
    field :search_products, resolver: Queries::SearchProductsQuery

    field :projects, resolver: Queries::ProjectsQuery
    field :project, resolver: Queries::ProjectQuery
    field :search_projects, resolver: Queries::SearchProjectsQuery

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

    field :countries, resolver: Queries::CountriesQuery
    field :search_countries, resolver: Queries::SearchCountriesQuery

    field :organizations, resolver: Queries::OrganizationsQuery
    field :organization, resolver: Queries::OrganizationQuery
    field :search_organizations, resolver: Queries::SearchOrganizationsQuery

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

    field :me, resolver: Queries::MeQuery
  end
end
