class RemoveUnusedTables < ActiveRecord::Migration[5.2]
  def change
    drop_table 'product_suites_product_versions'
    drop_table :product_suites
    drop_table :product_versions
  end
end
