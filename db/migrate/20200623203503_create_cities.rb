# frozen_string_literal: true

class CreateCities < ActiveRecord::Migration[5.2]
  def change
    create_table(:cities) do |t|
      t.string(:name, null: false)
      t.string(:slug, null: false)
      # Ramallah doesn't have country and region, so we need to make this optional.
      t.references(:region, foreign_key: true)
      t.decimal(:latitude, null: false)
      t.decimal(:longitude, null: false)
      t.string(:aliases, array: true, default: [])

      t.timestamps
    end
  end
end
