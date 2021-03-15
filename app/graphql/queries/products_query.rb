module Queries
  class ProductsQuery < Queries::BaseQuery

    type Types::ProductType.connection_type, null: false

    def resolve
      Product.all.order(:slug)
    end
  end
end