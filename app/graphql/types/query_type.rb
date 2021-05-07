module Types
  class QueryType < Types::BaseObject
    field :playbooks, resolver: Queries::PlaybooksQuery
    field :playbook, resolver: Queries::PlaybookQuery
    field :search_playbook, resolver: Queries::SearchPlaybookQuery
    field :page_contents, resolver: Queries::PageContentsQuery
    field :export_page_contents, resolver: Queries::ExportPageContentsQuery

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
    field :search_sectors, resolver: Queries::SearchSectorsQuery

    field :origins, resolver: Queries::OriginsQuery
    field :search_origins, resolver: Queries::SearchOriginsQuery

    field :use_cases, resolver: Queries::UseCasesQuery
    field :use_case, resolver: Queries::UseCaseQuery
    field :search_use_cases, resolver: Queries::SearchUseCasesQuery

    field :countries, resolver: Queries::CountriesQuery
    field :search_countries, resolver: Queries::SearchCountriesQuery

    field :organizations, resolver: Queries::OrganizationsQuery
    field :organization, resolver: Queries::OrganizationQuery
    field :search_organizations, resolver: Queries::SearchOrganizationsQuery

    field :sdgs, resolver: Queries::SustainableDevelopmentGoalsQuery
    field :sdg, resolver: Queries::SustainableDevelopmentGoalQuery
    field :search_sdgs, resolver: Queries::SearchSustainableDevelopmentGoalsQuery

    field :tags, resolver: Queries::TagsQuery

    field :wizard, resolver: Queries::WizardQuery

    field :workflows, resolver: Queries::WorkflowsQuery
    field :workflow, resolver: Queries::WorkflowQuery
    field :search_workflows, resolver: Queries::SearchWorkflowsQuery

    field :me, resolver: Queries::MeQuery
  end
end
