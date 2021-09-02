module Types
  class PageContentType < Types::BaseObject
    field :id, ID, null: false
    field :handbook_page_id, Integer, null: true
    field :locale, String, null: false
    field :html, String, null: false
    field :css, String, null: true
    field :components, String, null: true
    field :assets, String, null: true
    field :styles, String, null: true
    field :editor_type, String, null: true
  end
end
