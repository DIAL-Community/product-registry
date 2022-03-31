# frozen_string_literal: true

class CreateOrigins < ActiveRecord::Migration[5.1]
  def change
    create_table :origins do |t|
      t.references :organization
      t.string :name
      t.string :slug
      t.string :description
      t.datetime :last_synced

      t.timestamps
    end

    create_table 'products_origins', id: false, force: :cascade do |t|
      t.bigint 'product_id', null: false
      t.bigint 'origin_id', null: false
      t.index %w[product_id origin_id], name: 'products_origins_idx', unique: true
      t.index %w[origin_id product_id], name: 'origins_products_idx', unique: true
    end

    add_foreign_key 'products_origins', 'products', name: 'products_origins_product_fk'
    add_foreign_key 'products_origins', 'origins', name: 'products_origins_origin_fk'
  end
end
