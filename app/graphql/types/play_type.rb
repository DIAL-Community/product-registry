module Types
  class PlayDescriptionType < Types::BaseObject
    field :id, ID, null: false
    field :play_id, Integer, null: true
    field :locale, String, null: false
    field :description, String, null: false
  end

  class PlayType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :tags, GraphQL::Types::JSON, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :maturity, String, null: true
    field :image_file, String, null: true

    field :play_descriptions, [Types::PlayDescriptionType], null: true
    field :play_moves, [Types::MoveType], null: true
  end
end
