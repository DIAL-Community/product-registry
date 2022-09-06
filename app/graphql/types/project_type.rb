# frozen_string_literal: true

module Types
  class ProjectDescriptionType < Types::BaseObject
    field :id, ID, null: false
    field :project_id, Integer, null: true
    field :locale, String, null: false
    field :description, String, null: false
  end

  class ProjectType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :start_date, GraphQL::Types::ISO8601Date, null: true
    field :end_date, GraphQL::Types::ISO8601Date, null: true
    field :tags, GraphQL::Types::JSON, null: true
    field :project_website, String, null: true, method: :project_website_decoded
    field :project_descriptions, [Types::ProjectDescriptionType], null: true

    field :sectors, [Types::SectorType], null: true, method: :sectors_localized
    field :project_description, Types::ProjectDescriptionType, null: true,
                                                               method: :project_description_localized

    field :origin, Types::OriginType, null: true

    field :organizations, [Types::OrganizationType], null: true
    field :products, [Types::ProductType], null: true
    field :countries, [Types::CountryType], null: true
  end
end
