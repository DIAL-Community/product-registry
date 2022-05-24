# frozen_string_literal: true
class CreateDialSpreadsheetData < ActiveRecord::Migration[5.2]
  def change
    create_table(:dial_spreadsheet_data) do |t|
      t.string(:slug, null: false)
      t.string(:spreadsheet_type, null: false)
      t.jsonb(:spreadsheet_data, null: false, default: {})
      t.boolean(:deleted, null: false, default: false)
      t.bigint(:updated_by)
      t.datetime(:updated_date)
    end
  end
end
