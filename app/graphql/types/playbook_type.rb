module Types
  class PlaybookType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :phases, GraphQL::Types::JSON, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :maturity, String, null: true

    field :playbook_descriptions, [Types::PlaybookDescriptionType], null: true
    field :activities, [Types::ActivityType], null: true
  end
end
