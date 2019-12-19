class AddLicenseInformationToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :license, :string
    add_column :products, :license_analysis, :string
  end
end
