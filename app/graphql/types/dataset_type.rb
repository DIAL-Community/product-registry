# frozen_string_literal: true

module Types
  class DatasetDescriptionType < Types::BaseObject
    field :id, ID, null: false
    field :dataset_id, Integer, null: true
    field :locale, String, null: false
    field :description, String, null: false
  end

  class DatasetType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :image_file, String, null: false
    field :website, String, null: true
    field :visualization_url, String, null: true
    field :geographic_coverage, String, null: true
    field :time_range, String, null: true
    field :license, String, null: true
    field :languages, String, null: true
    field :data_format, String, null: true
    field :aliases, GraphQL::Types::JSON, null: true
    field :tags, GraphQL::Types::JSON, null: true
    field :dataset_type, String, null: false

    field :dataset_descriptions, [Types::DatasetDescriptionType], null: true

    field :sectors, [Types::SectorType], null: true, method: :sectors_localized
    field :dataset_description, Types::DatasetDescriptionType, null: true,
                                                               method: :dataset_description_localized

    field :origins, [Types::OriginType], null: true
    field :organizations, [Types::OrganizationType], null: true

    field :sustainable_development_goals, [Types::SustainableDevelopmentGoalType], null: true
    field :sustainable_development_goal_mapping, String,
      method: :current_sustainable_development_goal_mapping

    field :manual_update, Boolean, null: false
  end
end
