module Queries
  class TagsQuery < Queries::BaseQuery

    type [Types::TagType], null: false

    def resolve
      Tag.all.order(:slug)
    end
  end
end
