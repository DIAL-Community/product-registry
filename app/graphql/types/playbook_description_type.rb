module Types
  class PlaybookDescriptionType < Types::BaseObject
    field :id, ID, null: false
    field :playbook_id, Integer, null: true
    field :locale, String, null: false
    field :overview, GraphQL::Types::JSON, null: false
    field :audience, GraphQL::Types::JSON, null: false
    field :outcomes, GraphQL::Types::JSON, null: false
  end
end
