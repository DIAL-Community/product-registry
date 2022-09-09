# frozen_string_literal: true

module Queries
  class CategoryIndicatorQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::CategoryIndicatorType, null: true

    def resolve(slug:)
      category_indicator = CategoryIndicator.find_by(slug: slug) if an_admin
      category_indicator
    end
  end
end
