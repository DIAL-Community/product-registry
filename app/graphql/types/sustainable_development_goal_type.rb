module Types
  class SustainableDevelopmentGoalType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :long_title, String, null: false
    field :number, Integer, null: false
    field :image_file, String, null: true

    field :sdg_targets, [Types::SustainableDevelopmentGoalTargetType], null: false
  end
end
