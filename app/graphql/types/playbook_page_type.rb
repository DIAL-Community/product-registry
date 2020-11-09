module Types
  class PlaybookPageType < Types::BaseObject
    field :id, ID, null: false
    field :playbook_id, Integer, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :phase, String, null: true
    field :page_order, Integer, null: true
    field :parent_page_id, Integer, null: true
    field :resources, GraphQL::Types::JSON, null: false
    field :playbook_questions_id, Integer, null: true
    field :media_url, String, null: true

    field :child_pages, [Types::PlaybookPageType], null: true
    field :page_contents, [Types::PageContentType], null: true
  end
end
