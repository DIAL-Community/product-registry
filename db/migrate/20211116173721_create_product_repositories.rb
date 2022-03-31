# frozen_string_literal: true

class CreateProductRepositories < ActiveRecord::Migration[5.2]
  def change
    create_table(:product_repositories) do |t|
      t.string(:name, null: false)
      t.string(:slug, null: false)

      t.references(:product, foreign_key: true, null: false)

      t.string(:absolute_url, null: false)
      t.string(:description, null: false)
      t.boolean(:main_repository, null: false, default: false)

      t.jsonb(:dpga_data, null: false, default: {})
      t.jsonb(:language_data, null: false, default: {})
      t.jsonb(:statistical_data, null: false, default: {})

      t.jsonb(:license_data, null: false, default: {})
      t.string(:license, null: false, default: 'NA')

      t.integer(:code_lines)
      t.integer(:cocomo)
      t.integer(:est_hosting)
      t.integer(:est_invested)

      t.datetime(:updated_at, null: true)
      t.bigint(:updated_by, null: true)

      t.boolean(:deleted, null: false, default: false)
      t.datetime(:deleted_at, null: true)
      t.bigint(:deleted_by, null: true)

      t.timestamps
    end
  end
end
