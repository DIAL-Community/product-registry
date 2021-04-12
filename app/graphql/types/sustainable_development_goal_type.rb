module Types
  class SustainableDevelopmentGoalType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :long_title, String, null: false
    field :image_file, String, null: true
  end
end
