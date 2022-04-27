# frozen_string_literal: true

class CreateStylesheets < ActiveRecord::Migration[5.1]
  def change
    create_table(:stylesheets) do |t|
      t.string(:portal)
      t.string(:background_color)
      t.jsonb(:about_page, null: false, default: '{}')
      t.jsonb(:footer_content, null: false, default: '{}')
      t.string(:header_logo)
    end
  end
end
