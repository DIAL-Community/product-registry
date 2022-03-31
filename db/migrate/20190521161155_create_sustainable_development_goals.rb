# frozen_string_literal: true

class CreateSustainableDevelopmentGoals < ActiveRecord::Migration[5.1]
  def change
    create_table :sustainable_development_goals do |t|
      t.string :slug
      t.string :name
      t.string :long_title
      t.integer :number

      t.timestamps
      t.index ['slug'], name: 'index_sdgs_on_slug', unique: true
    end

    create_table 'products_sustainable_development_goals', id: false, force: :cascade do |t|
      t.bigint 'product_id', null: false
      t.bigint 'sustainable_development_goal_id', null: false
      t.index %w[sustainable_development_goal_id product_id], name: 'sdgs_prods', unique: true
      t.index %w[product_id sustainable_development_goal_id], name: 'prod_sdgs', unique: true
    end

    add_foreign_key 'products_sustainable_development_goals', 'products', name: 'products_sdgs_product_fk'
    add_foreign_key 'products_sustainable_development_goals', 'sustainable_development_goals',
                    name: 'products_sdgs_sdg_fk'
  end
end
