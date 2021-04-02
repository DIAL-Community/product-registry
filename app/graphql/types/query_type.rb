module Types

  class QueryType < Types::BaseObject

    field :playbooks, resolver: Queries::PlaybooksQuery
    field :playbook, resolver: Queries::PlaybookQuery
    field :search_playbook, resolver: Queries::SearchPlaybookQuery
    field :page_contents, resolver: Queries::PageContentsQuery
    field :export_page_contents, resolver: Queries::ExportPageContentsQuery

    field :products, resolver: Queries::ProductsQuery
    field :building_blocks, resolver: Queries::BuildingBlocksQuery

    field :sectors, resolver: Queries::SectorsQuery
    field :use_cases, resolver: Queries::UseCasesQuery
    field :countries, resolver: Queries::CountriesQuery
    field :tags, resolver: Queries::TagsQuery

    field :wizard, resolver: Queries::WizardQuery

    field :me, resolver: Queries::MeQuery
  end
end