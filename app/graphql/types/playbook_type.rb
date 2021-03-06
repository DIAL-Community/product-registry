module Types
  class PlaybookType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :phases, GraphQL::Types::JSON, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :maturity, String, null: true
    field :image_file, String, null: true
    field :pdf_url, String, null: true

    field :playbook_pages, [Types::PlaybookPageType], null: true
    field :playbook_descriptions, [Types::PlaybookDescriptionType], null: true
  end
end
