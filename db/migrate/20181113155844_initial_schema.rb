# frozen_string_literal: true

class InitialSchema < ActiveRecord::Migration[5.1]
  def change
    create_table('organizations', force: :cascade) do |t|
      t.string('name')
      t.string('slug', unique: true, null: false)
      t.datetime('when_endorsed')
      t.string('website')
      t.boolean('is_endorser')

      t.timestamps
    end

    create_table('locations', force: :cascade) do |t|
      t.string('name')
      t.string('slug', unique: true, null: false)
      t.point('points', array: true)

      t.timestamps
    end

    create_table('products', force: :cascade) do |t|
      t.string('name')
      t.string('slug', unique: true, null: false)
      t.string('website')

      t.timestamps
    end

    create_table(:contacts) do |t|
      t.string('name')
      t.string('slug', unique: true, null: false)
      t.string('email')
      t.string('title')

      t.timestamps
    end

    create_table('organizations_locations', id: false, force: :cascade) do |t|
      t.bigint('location_id', null: false)
      t.bigint('organization_id', null: false)
      t.index(%w[location_id organization_id], name: 'loc_orcs')
      t.index(%w[organization_id location_id], name: 'org_locs')
    end

    create_table('organizations_products', id: false, force: :cascade) do |t|
      t.bigint('organization_id', null: false)
      t.bigint('product_id', null: false)
      t.index(%w[organization_id product_id], name: 'index_organizations_products_on_organization_id_and_product_id')
      t.index(%w[product_id organization_id], name: 'index_organizations_products_on_product_id_and_organization_id')
    end

    create_table('organizations_contacts', id: false, force: :cascade) do |t|
      t.bigint('organization_id', null: false)
      t.bigint('contact_id', null: false)
      t.datetime('started_at')
      t.datetime('ended_at')
      t.index(%w[organization_id contact_id], name: 'index_organizations_contacts_on_organization_id_and_contact_id')
      t.index(%w[contact_id organization_id], name: 'index_organizations_contacts_on_contact_id_and_organization_id')
    end
  end
end
