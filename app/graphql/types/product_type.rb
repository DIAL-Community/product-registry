module Types
  class ProductDescriptionType < Types::BaseObject
    field :id, ID, null: false
    field :product_id, Integer, null: true
    field :locale, String, null: false
    field :description, String, null: false
  end

  class EndorserType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
  end

  class ProductType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :image_file, String, null: false
    field :website, String, null: true
    field :repository, String, null: true
    field :license, String, null: true
    field :statistics, GraphQL::Types::JSON, null: true
    field :language_data, GraphQL::Types::JSON, null: true
    field :owner, String, null: true
    field :code_lines, Integer, null: true
    field :cocomo, Integer, null: true

    field :is_launchable, Boolean, null: true
    field :product_type, String, null: false

    field :license, String, null: true
    field :maturity_score, Integer, null: true

    field :tags, [String], null: true

    field :product_descriptions, [Types::ProductDescriptionType], null: true
    field :origins, [Types::OriginType], null: true
    field :endorsers, [Types::EndorserType], null: true
    field :organizations, [Types::OrganizationType], null: true
    field :currProjects, [Types::ProjectType], null: true do
      argument :first, Integer, required: false
    end
    field :building_blocks, [Types::BuildingBlockType], null: true
    field :sustainable_development_goals, [Types::SustainableDevelopmentGoalType], null: true
    field :sectors, [Types::SectorType], null: true
    field :child_products, [Types::ProductType], null: true
    field :interoperates_with, [Types::ProductType], null: true
    field :includes, [Types::ProductType], null: true
    field :maturity_scores, GraphQL::Types::JSON, null: true
  end
end
