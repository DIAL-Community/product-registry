class CreateOffices < ActiveRecord::Migration[5.2]
  def change
    create_table :offices do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.decimal :latitude, null: false
      t.decimal :longitude, null: false
      t.string :city, null: false
      t.references :organization, foreign_key: true, null: false
      t.references :region, foreign_key: true
      t.references :country, foreign_key: true

      t.timestamps
    end
  end
end
