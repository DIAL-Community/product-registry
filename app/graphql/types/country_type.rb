# frozen_string_literal: true

module Types
  class CountryType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :code, String, null: false
    field :code_longer, String, null: false
    field :latitude, String, null: false
    field :longitude, String, null: false
    field :aliases, [String], null: false
  end
end
