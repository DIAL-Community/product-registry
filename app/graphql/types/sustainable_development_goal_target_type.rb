# frozen_string_literal: true

module Types
  class SustainableDevelopmentGoalTargetType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :target_number, String, null: false
    field :sdg_number, String, null: false
    field :image_file, String, null: true

    field :use_cases, [Types::UseCaseType], null: true
    field :sustainable_development_goal, Types::SustainableDevelopmentGoalType, null: false
  end
end
