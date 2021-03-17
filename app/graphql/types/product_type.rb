module Types
  class ProductType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :image_file, String, null: false

    field :product_descriptions, [Types::ProductDescriptionType], null: true
  end
end