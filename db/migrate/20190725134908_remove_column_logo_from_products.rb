class RemoveColumnLogoFromProducts < ActiveRecord::Migration[5.1]
  def change
    remove_column :products, :logo
  end
end
