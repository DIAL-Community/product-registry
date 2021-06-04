module Queries
  class TagsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::TagType], null: false

    def resolve(search:)
      tags = Tag.order(:name)
      unless search.blank?
        tags = tags.name_contains(search)
      end
      tags
    end
  end
end
