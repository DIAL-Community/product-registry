class AddFavoritedEntities < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :saved_products, :bigint, array: true, default: []
    add_column :users, :saved_use_cases, :bigint, array: true, default: []
    add_column :users, :saved_projects, :bigint, array: true, default: []
  end
end
