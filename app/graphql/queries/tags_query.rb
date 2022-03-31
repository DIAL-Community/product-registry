# frozen_string_literal: true

module Queries
  class TagsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::TagType], null: false

    def resolve(search:)
      tags = Tag.order(:name)
      tags = tags.name_contains(search) unless search.blank?
      tags
    end
  end
end
