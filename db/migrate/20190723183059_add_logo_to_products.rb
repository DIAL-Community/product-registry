class AddLogoToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :logo, :string
  end
end
