# frozen_string_literal: true

module Types
  class HandbookDescriptionType < Types::BaseObject
    field :id, ID, null: false
    field :handbook_id, Integer, null: true
    field :locale, String, null: false
    field :overview, String, null: false
    field :audience, String, null: false
    field :outcomes, String, null: false
    field :cover, String, null: true
  end

  class HandbookType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :phases, GraphQL::Types::JSON, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :maturity, String, null: true
    field :image_file, String, null: true
    field :pdf_url, String, null: true

    field :handbook_pages, [Types::HandbookPageType], null: true
    field :handbook_descriptions, [Types::HandbookDescriptionType], null: true
  end
end
