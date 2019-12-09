class CreateProductVersions < ActiveRecord::Migration[5.1]
  def change
    create_table :product_versions do |t|
      t.references :product, foreign_key: true
      t.string :version, unique: true, null: false
      t.integer :version_order, unique: true, null: false
    end
  end
end
