# frozen_string_literal: true

module Queries
  class SpreadsheetDatasetQuery < Queries::BaseQuery
    type [Types::DialSpreadsheetDataType], null: false

    def resolve
      DialSpreadsheetData.where(spreadsheet_type: 'dataset').order(slug: 'ASC')
    end
  end
end
