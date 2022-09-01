# frozen_string_literal: true

module Types
  class TagDescriptionType < Types::BaseObject
    field :id, ID, null: false
    field :tag_id, Integer, null: true
    field :locale, String, null: false
    field :description, String, null: false
  end

  class TagType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :tag_descriptions, [Types::TagDescriptionType], null: true
    field :tag_description, Types::TagDescriptionType, null: true, method: :tag_description_localized
  end
end
