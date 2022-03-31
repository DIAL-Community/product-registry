# frozen_string_literal: true

class AddTagDescriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :tag_descriptions do |t|
      t.references :tag, foreign_key: true
      t.string :locale, null: false
      t.jsonb :description, null: false, default: '{}'
    end
  end
end
