class CreateRegions < ActiveRecord::Migration[5.2]
  def change
    create_table :regions do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.references :country, foreign_key: true, null: false
      t.decimal :latitude, null: false
      t.decimal :longitude, null: false
      t.string :aliases, array: true, default: []

      t.timestamps
    end
  end
end
