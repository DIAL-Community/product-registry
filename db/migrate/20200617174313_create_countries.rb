# frozen_string_literal: true

class CreateCountries < ActiveRecord::Migration[5.2]
  def change
    create_table(:countries) do |t|
      t.string(:name, null: false, unique: true)
      t.string(:slug, null: false)
      t.string(:code, null: false)
      t.string(:code_longer, null: false)
      t.decimal(:latitude, null: false)
      t.decimal(:longitude, null: false)
      t.string(:aliases, array: true, default: [])

      t.timestamps
    end
  end
end
