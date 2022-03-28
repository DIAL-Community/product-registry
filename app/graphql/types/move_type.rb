# frozen_string_literal: true

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
    field :order, Integer, null: true
    field :resources, GraphQL::Types::JSON, null: false

    field :move_descriptions, [Types::MoveDescriptionType], null: true
    field :move_description, Types::MoveDescriptionType, null: true,
                                                         method: :move_description_localized

    field :play_name, String, null: true
    field :play_slug, String, null: true
  end
end
