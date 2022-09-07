# frozen_string_literal: true

module Queries
  class RubricCategoriesQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper
    argument :search, String, required: false
    type Types::RubricCategoryType.connection_type, null: false

    def resolve(search:)
      rubric_categories = []
      rubric_categories = RubricCategory.name_contains(search).order(:name) if an_admin
      rubric_categories
    end
  end

  class RubricCategoryQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::RubricCategoryType, null: true

    def resolve(slug:)
      rubric_category = RubricCategory.find_by(slug: slug) if an_admin
      rubric_category
    end
  end
end
