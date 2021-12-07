module Types
  class ProductRepositoryType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: true
    field :slug, String, null: false
    field :description, String, null: false
    field :absolute_url, String, null: false
    field :main_repository, String, null: false

    field :license, String, null: true

    field :statistical_data, GraphQL::Types::JSON, null: true
    field :language_data, GraphQL::Types::JSON, null: true

    field :product, Types::ProductType, null: true
  end
end
