# frozen_string_literal: true

module Types
  class RubricCategoryDescriptionType < Types::BaseObject
    field :id, ID, null: false
    field :rubric_category_id, Integer, null: true
    field :locale, String, null: false
    field :description, String, null: false
  end

  class RubricCategoryType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :weight, Float, null: false

    field :rubric_category_descriptions, [Types::RubricCategoryDescriptionType], null: true
    field :rubric_category_description, Types::RubricCategoryDescriptionType, null: true,
                                                               method: :rubric_category_description_localized

    field :category_indicators, [Types::CategoryIndicatorType], null: true
  end
end
