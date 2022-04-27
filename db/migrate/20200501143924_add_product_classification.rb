# frozen_string_literal: true

class AddProductClassification < ActiveRecord::Migration[5.2]
  def change
    create_table(:classifications) do |t|
      t.string(:name)
      t.string(:indicator)
      t.string(:description)
      t.string(:source)

      t.timestamps
    end

    create_table(:product_classifications) do |t|
      t.references(:product, foreign_key: true)
      t.references(:classification, foreign_key: true)
      t.index(%w[classification_id product_id], name: 'classifications_products_idx', unique: true)
      t.index(%w[product_id classification_id], name: 'products_classifications_idx', unique: true)
    end

    add_foreign_key('product_classifications', 'classifications', name: 'product_classifications_classification_fk')
    add_foreign_key('product_classifications', 'products', name: 'product_classifications_product_fk')
  end
end
