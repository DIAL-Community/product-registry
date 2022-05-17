# frozen_string_literal: true

module Types
  class DialSpreadsheetDataType < Types::BaseObject
    field :id, ID, null: false
    field :slug, String, null: false
    field :spreadsheet_type, String, null: false
    field :spreadsheet_data, GraphQL::Types::JSON, null: false
  end
end
