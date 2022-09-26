# frozen_string_literal: true

module Types
  class CategoryIndicatorDescriptionType < Types::BaseObject
    field :id, ID, null: false
    field :category_indicator_id, Integer, null: true
    field :locale, String, null: false
    field :description, String, null: false
  end

  class CategoryIndicatorType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :indicator_type, String, null: true
    field :weight, Float, null: false
    field :rubric_category_id, Integer, null: true
    field :data_source, String, null: true
    field :source_indicator, String, null: true
    field :script_name, String, null: true

    field :category_indicator_descriptions, [Types::CategoryIndicatorDescriptionType], null: true
    field :category_indicator_description, Types::CategoryIndicatorDescriptionType, null: true,
                                                               method: :category_indicator_description_localized
  end
end
