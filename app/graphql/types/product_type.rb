module Types
  class ProductDescriptionType < Types::BaseObject
    field :id, ID, null: false
    field :product_id, Integer, null: true
    field :locale, String, null: false
    field :description, String, null: false
  end
  
  class ProductType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :image_file, String, null: false

    field :product_descriptions, [Types::ProductDescriptionType], null: true
  end
end