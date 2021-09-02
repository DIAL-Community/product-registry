module Types
  class HandbookSearchPageType < Types::BaseObject
    field :id, ID, null: false
    field :handbook_id, Integer, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :parent_page_id, Integer, null: true
    field :resources, GraphQL::Types::JSON, null: false

    field :snippet, String, null: true

    field :child_pages, [Types::HandbookSearchPageType], null: true
    field :child_pages, [Types::HandbookSearchPageType], null: true
  end
end
