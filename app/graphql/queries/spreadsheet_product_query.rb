# frozen_string_literal: true

module Queries
  class SpreadsheetProductQuery < Queries::BaseQuery
    type [Types::DialSpreadsheetDataType], null: false

    def resolve
      DialSpreadsheetData.where(spreadsheet_type: 'product').order(slug: 'ASC')
    end
  end
end
