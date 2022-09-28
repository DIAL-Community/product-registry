# frozen_string_literal: true

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
    field :aliases, GraphQL::Types::JSON, null: true
    field :tags, GraphQL::Types::JSON, null: true
    field :owner, String, null: true

    field :is_launchable, Boolean, null: true
    field :product_type, String, null: false

    field :maturity_score, Integer, null: true

    field :main_repository, Types::ProductRepositoryType, null: true

    field :product_descriptions, [Types::ProductDescriptionType], null: true

    field :sectors, [Types::SectorType], null: true, method: :sectors_localized
    field :product_description, Types::ProductDescriptionType, null: true,
                                                               method: :product_description_localized

    field :origins, [Types::OriginType], null: true
    field :endorsers, [Types::EndorserType], null: true
    field :organizations, [Types::OrganizationType], null: true

    field :current_projects, [Types::ProjectType], null: true do
      argument :first, Integer, required: false
    end

    field :projects, [Types::ProjectType], null: true

    field :building_blocks, [Types::BuildingBlockType], null: true
    field :building_blocks_mapping_status, String,
      method: :building_blocks_mapping_status
    field :sustainable_development_goals, [Types::SustainableDevelopmentGoalType], null: true
    field :sustainable_development_goals_mapping_status, String,
      method: :sustainable_development_goals_mapping_status

    field :interoperates_with, [Types::ProductType], null: true
    field :includes, [Types::ProductType], null: true
    field :maturity_scores, GraphQL::Types::JSON, null: true
    field :manual_update, Boolean, null: false

    field :commercial_product, Boolean, null: false
    field :pricing_model, String, null: true
    field :pricing_details, String, null: true
    field :hosting_model, String, null: true
  end
end
