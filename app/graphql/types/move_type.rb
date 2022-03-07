module Types
  class MoveDescriptionType < Types::BaseObject
    field :id, ID, null: false
    field :move_id, Integer, null: true
    field :locale, String, null: false
    field :description, String, null: false
  end

  class MoveType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :resources, GraphQL::Types::JSON, null: false
    field :move_descriptions, [Types::MoveDescriptionType], null: true
    field :play_name, String, null: true
    field :play_slug, String, null: true
  end
end
