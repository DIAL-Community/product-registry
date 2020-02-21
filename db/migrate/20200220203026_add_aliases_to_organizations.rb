class AddAliasesToOrganizations < ActiveRecord::Migration[5.1]
  def change
    add_column :organizations, :aliases, :string, array: true, default: []
  end
end
