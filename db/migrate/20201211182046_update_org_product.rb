class UpdateOrgProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :organizations_products, :org_type_tmp, :org_type, :default => 'owner'

    OrganizationsProduct.reset_column_information # make the new column available to model methods
    OrganizationsProduct.all.each do |org_prod|
      org_prod.org_type_tmp = org_prod.org_type
      org_prod.save
    end

    remove_column :organizations_products, :org_type
    rename_column :organizations_products, :org_type_tmp, :org_type
  end
end
