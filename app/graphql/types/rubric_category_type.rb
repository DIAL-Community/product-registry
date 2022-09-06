# frozen_string_literal: true

module Types
  class RubricCategoryType < Types::BaseObject
    field :name, String, null: false
    field :slug, String, null: false
    field :weight, Float, null: false
  end
end
