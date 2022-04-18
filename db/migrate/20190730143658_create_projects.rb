# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table(:projects) do |t|
      t.references(:origin, foreign_key: true)
      t.date(:start_date)
      t.date(:end_date)
      t.decimal(:budget, precision: 12, scale: 2)

      t.timestamps
    end

    create_table('projects_organizations', id: false, force: :cascade) do |t|
      t.bigint('project_id', null: false)
      t.bigint('organization_id', null: false)
      t.index(%w[project_id organization_id], name: 'projects_organizations_idx', unique: true)
      t.index(%w[organization_id project_id], name: 'organizations_projects_idx', unique: true)
    end

    add_foreign_key('projects_organizations', 'projects', name: 'projects_organizations_project_fk')
    add_foreign_key('projects_organizations', 'organizations', name: 'projects_organizations_organization_fk')

    create_table('projects_locations', id: false, force: :cascade) do |t|
      t.bigint('project_id', null: false)
      t.bigint('location_id', null: false)
      t.index(%w[project_id location_id], name: 'projects_locations_idx', unique: true)
      t.index(%w[location_id project_id], name: 'locations_projects_idx', unique: true)
    end

    add_foreign_key('projects_locations', 'projects', name: 'projects_locations_project_fk')
    add_foreign_key('projects_locations', 'locations', name: 'projects_locations_location_fk')

    create_table('projects_products', id: false, force: :cascade) do |t|
      t.bigint('project_id', null: false)
      t.bigint('product_id', null: false)
      t.index(%w[project_id product_id], name: 'projects_products_idx', unique: true)
      t.index(%w[product_id project_id], name: 'products_projects_idx', unique: true)
    end

    add_foreign_key('projects_products', 'projects', name: 'projects_products_project_fk')
    add_foreign_key('projects_products', 'products', name: 'projects_products_product_fk')

    create_table('projects_sectors', id: false, force: :cascade) do |t|
      t.bigint('project_id', null: false)
      t.bigint('sector_id', null: false)
      t.index(%w[project_id sector_id], name: 'projects_sectors_idx', unique: true)
      t.index(%w[sector_id project_id], name: 'sectors_projects_idx', unique: true)
    end

    add_foreign_key('projects_sectors', 'projects', name: 'projects_sectors_project_fk')
    add_foreign_key('projects_sectors', 'sectors', name: 'projects_sectors_sector_fk')

    create_table('projects_sdgs', id: false, force: :cascade) do |t|
      t.bigint('project_id', null: false)
      t.bigint('sdg_id', null: false)
      t.index(%w[project_id sdg_id], name: 'projects_sdgs_idx', unique: true)
      t.index(%w[sdg_id project_id], name: 'sdgs_projects_idx', unique: true)
    end

    add_foreign_key('projects_sdgs', 'projects', name: 'projects_sdgs_project_fk')
    add_foreign_key('projects_sdgs', 'sustainable_development_goals', column: :sdg_id, primary_key: :id,
                                                                      name: 'projects_sdgs_sdg_fk')
  end
end
