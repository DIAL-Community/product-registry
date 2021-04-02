module Types
  class PlaybookDescriptionType < Types::BaseObject
    field :id, ID, null: false
    field :playbook_id, Integer, null: true
    field :locale, String, null: false
    field :overview, String, null: false
    field :audience, String, null: false
    field :outcomes, String, null: false
    field :cover, String, null: true
  end

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
