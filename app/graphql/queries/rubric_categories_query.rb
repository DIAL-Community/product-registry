# frozen_string_literal: true

module Queries
  class RubricCategoriesQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper

    type Types::RubricCategoryType.connection_type, null: false

    def resolve
      rubric_categories = []
      rubric_categories = RubricCategory.all.order(:name) if an_admin
      rubric_categories
    end
  end
end
