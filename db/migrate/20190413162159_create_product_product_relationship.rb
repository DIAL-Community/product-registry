# frozen_string_literal: true

class CreateProductProductRelationship < ActiveRecord::Migration[5.1]
  def change
    create_table :product_product_relationships do |t|
      t.bigint :from_product_id, null: false
      t.bigint :to_product_id, null: false
      t.string 'relationship_type', null: false, limit: 16
      t.index %w[from_product_id to_product_id], name: 'product_rel_index', unique: true
    end
    add_foreign_key :product_product_relationships, :products, column: :from_product_id, name: 'from_product_fk'
    add_foreign_key :product_product_relationships, :products, column: :to_product_id, name: 'to_product_fk'
  end
end
