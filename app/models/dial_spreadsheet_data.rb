# frozen_string_literal: true

class DialSpreadsheetData < ApplicationRecord
  scope :slug_starts_with, ->(slug) { where('LOWER(dial_spreadsheet_data.slug) like LOWER(?)', "#{slug}%\\_") }
end
