# frozen_string_literal: true

class CreateGlossaries < ActiveRecord::Migration[5.1]
  def change
    create_table(:glossaries) do |t|
      t.string(:name, null: false)
      t.string(:slug, null: false)
      t.string(:locale, null: false)
      t.jsonb(:description, null: false, default: '{}')

      t.timestamps
    end
  end
end
