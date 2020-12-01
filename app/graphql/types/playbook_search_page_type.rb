module Types
  class PlaybookSearchPageType < Types::BaseObject
    field :id, ID, null: false
    field :playbook_id, Integer, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :parent_page_id, Integer, null: true
    field :resources, GraphQL::Types::JSON, null: false

    field :snippet, String, null: true

    field :child_pages, [Types::PlaybookSearchPageType], null: true
    field :child_pages, [Types::PlaybookSearchPageType], null: true
  end
end
