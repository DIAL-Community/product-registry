class AddDbConstraints < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :organizations_contacts, :organizations, :name => :organizations_contacts_organization_fk
    add_foreign_key :organizations_contacts, :contacts, :name => :organizations_contacts_contact_fk

    add_foreign_key :organizations_locations, :organizations, :name => :organizations_locations_organization_fk
    add_foreign_key :organizations_locations, :locations, :name => :organizations_locations_location_fk

    add_foreign_key :organizations_products, :organizations, :name => :organizations_products_organization_fk
    add_foreign_key :organizations_products, :products, :name => :organizations_products_product_fk

    add_foreign_key :organizations_sectors, :organizations, :name => :organizations_sectors_organization_fk
    add_foreign_key :organizations_sectors, :sectors, :name => :organizations_sectors_sector_fk

    add_foreign_key :products_building_blocks, :products, :name => :products_building_blocks_product_fk
    add_foreign_key :products_building_blocks, :building_blocks, :name => :products_building_blocks_building_block_fk

    add_index :building_blocks, :slug, unique: true
    add_index :contacts, :slug, unique: true
    add_index :locations, :slug, unique: true
    add_index :organizations, :slug, unique: true
    add_index :products, :slug, unique: true
    add_index :sectors, :slug, unique: true

    remove_index :organizations_locations, column: [:location_id, :organization_id], name: "loc_orcs"
    remove_index :organizations_locations, column: [:organization_id, :location_id], name: "org_locs"
    remove_index :organizations_products, column: [:organization_id, :product_id], name: "index_organizations_products_on_organization_id_and_product_id"
    remove_index :organizations_products, column: [:product_id, :organization_id], name: "index_organizations_products_on_product_id_and_organization_id"
    remove_index :organizations_contacts, column: [:organization_id, :contact_id], name: "index_organizations_contacts_on_organization_id_and_contact_id"
    remove_index :organizations_contacts, column: [:contact_id, :organization_id], name: "index_organizations_contacts_on_contact_id_and_organization_id"
    remove_index :organizations_sectors, column: [:sector_id, :organization_id], name: "sector_orcs"
    remove_index :organizations_sectors, column: [:organization_id, :sector_id], name: "org_sectors"
    remove_index :products_building_blocks, column: [:product_id, :building_block_id], name: "prod_blocks"
    remove_index :products_building_blocks, column: [:building_block_id, :product_id], name: "block_prods"

    add_index :organizations_locations, [:location_id, :organization_id], name: "loc_orcs", unique: true
    add_index :organizations_locations, [:organization_id, :location_id], name: "org_locs", unique: true
    add_index :organizations_products, [:organization_id, :product_id], name: "index_organizations_products_on_organization_id_and_product_id", unique: true
    add_index :organizations_products, [:product_id, :organization_id], name: "index_organizations_products_on_product_id_and_organization_id", unique: true
    add_index :organizations_contacts, [:organization_id, :contact_id], name: "index_organizations_contacts_on_organization_id_and_contact_id", unique: true
    add_index :organizations_contacts, [:contact_id, :organization_id], name: "index_organizations_contacts_on_contact_id_and_organization_id", unique: true
    add_index :organizations_sectors, [:sector_id, :organization_id], name: "sector_orcs", unique: true
    add_index :organizations_sectors, [:organization_id, :sector_id], name: "org_sectors", unique: true
    add_index :products_building_blocks, [:product_id, :building_block_id], name: "prod_blocks", unique: true
    add_index :products_building_blocks, [:building_block_id, :product_id], name: "block_prods", unique: true
  end
end
