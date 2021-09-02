module Types
  class HandbookPageType < Types::BaseObject
    field :id, ID, null: false
    field :handbook_id, Integer, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :phase, String, null: true
    field :page_order, Integer, null: true
    field :parent_page_id, Integer, null: true
    field :resources, GraphQL::Types::JSON, null: false
    field :media_url, String, null: true

    field :child_pages, [Types::HandbookPageType], null: true
    field :page_contents, [Types::PageContentType], null: true
    field :handbook_question, Types::HandbookQuestionType, null: true
  end
end
