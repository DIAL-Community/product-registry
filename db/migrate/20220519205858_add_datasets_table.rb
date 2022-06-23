# frozen_string_literal: true
class AddDatasetsTable < ActiveRecord::Migration[5.2]
  def change
    create_table(:datasets) do |t|
      t.string(:name, null: false)
      t.string(:slug, null: false)
      t.string(:aliases, array: true, default: [])
      t.string(:website, null: false)
      t.string(:visualization_url, null: true)
      t.string(:tags, array: true, default: [])
      t.string(:dataset_type, null: false)
      t.string(:geographic_coverage, null: true)
      t.string(:time_range, null: true)
      t.boolean(:manual_update, default: false)

      t.timestamps
    end

    create_table(:dataset_descriptions) do |t|
      t.references(:dataset, foreign_key: true)
      t.string(:locale, null: false)
      t.string(:description, null: false, default: '')

      t.timestamps
    end

    create_table(:datasets_countries) do |t|
      t.references(:dataset, foreign_key: true, null: false)
      t.references(:country, foreign_key: true, null: false)
    end

    create_table(:dataset_sectors) do |t|
      t.references(:dataset, foreign_key: true, null: false)
      t.references(:sector, foreign_key: true, null: false)
      t.column(:mapping_status, :mapping_status_type, null: false, default: 'BETA')
      t.string(:slug, null: false)
    end

    create_table(:datasets_origins) do |t|
      t.references(:dataset, foreign_key: true, null: false)
      t.references(:origin, foreign_key: true, null: false)
    end

    create_table(:dataset_sustainable_development_goals, force: :cascade) do |t|
      t.references(:dataset, null: false)
      t.references(:sustainable_development_goal, null: false, index: { name: "dataset_sdg_index_on_sdg_id" })
      t.column(:mapping_status, :mapping_status_type, null: false, default: 'BETA')
      t.string(:slug, null: false)
    end

    create_table(:organizations_datasets) do |t|
      t.references(:organization, foreign_key: true, null: false)
      t.references(:dataset, foreign_key: true, null: false)
      t.column(:organization_type, :org_type, null: false, default: 'owner')
      t.string(:slug, null: false)
    end
  end
end
