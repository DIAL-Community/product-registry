# frozen_string_literal: true

module Types
  class OriginType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: true
    field :slug, String, null: false
  end
end
