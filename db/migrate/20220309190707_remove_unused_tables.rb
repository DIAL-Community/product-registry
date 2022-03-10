class RemoveUnusedTables < ActiveRecord::Migration[5.2]
  def change
    drop_table 'product_suites_product_versions'
    drop_table :product_suites
    drop_table :product_versions

    drop_table :commontator_subscriptions
    drop_table :commontator_comments
    drop_table :commontator_threads

    drop_table :votes

    remove_column :operator_services, :locations_id
    drop_table :projects_locations
    drop_table :organizations_locations
    drop_table :locations
    
  end
end
