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

  class TagQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::TagType, null: false

    def resolve(slug:)
      Tag.find_by(slug: slug)
    end
  end

  class SearchTagsQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper

    argument :search, String, required: false, default_value: ''
    type Types::TagType.connection_type, null: false

    def resolve(search:)
      tags = Tag.order(:name)
      tags = tags.name_contains(search) unless search.blank?
      tags
    end
  end
end
