# frozen_string_literal: true

module Types
  class BuildingBlockDescriptionType < Types::BaseObject
    field :id, ID, null: false
    field :building_block_id, Integer, null: true
    field :locale, String, null: false
    field :description, String, null: false
  end

  class BuildingBlockType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :image_file, String, null: true
    field :maturity, String, null: true
    field :spec_url, String, null: true

    field :building_block_descriptions, [Types::BuildingBlockDescriptionType], null: true
    field :building_block_description, Types::BuildingBlockDescriptionType, null: true,
          method: :building_block_description_localized

    field :workflows, [Types::WorkflowType], null: true
    field :products, [Types::ProductType], null: true
  end
end
