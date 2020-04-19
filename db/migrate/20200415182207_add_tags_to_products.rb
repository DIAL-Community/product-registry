class AddTagsToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :tags, :string, array: true, default: []
  end
end
