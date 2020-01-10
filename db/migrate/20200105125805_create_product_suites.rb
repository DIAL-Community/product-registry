class CreateProductSuites < ActiveRecord::Migration[5.1]
  def change
    create_table :product_suites do |t|
      t.string :name
      t.string :slug, unique: true, null: false
      t.string :description

      t.timestamps
    end

    create_table 'product_suites_product_versions', id: false, force: :cascade do |t|
      t.bigint 'product_suite_id', null: false
      t.bigint 'product_version_id', null: false
      t.index ['product_suite_id', 'product_version_id'], name: 'product_suites_products_versions'
      t.index ['product_version_id', 'product_suite_id'], name: 'products_versions_product_suites'
    end

    add_foreign_key 'product_suites_product_versions', 'product_suites', name: 'pspv_product_suites_fk'
    add_foreign_key 'product_suites_product_versions', 'product_versions', name: 'pspv_product_versions_fk'
  end
end
