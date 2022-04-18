# frozen_string_literal: true

class CreateTableUseCaseStepsProducts < ActiveRecord::Migration[5.2]
  def change
    create_table(:use_case_steps_products) do |t|
      t.bigint('use_case_step_id', null: false)
      t.bigint('product_id', null: false)
      t.index(%w[use_case_step_id product_id], name: 'use_case_steps_products_idx', unique: true)
      t.index(%w[product_id use_case_step_id], name: 'products_use_case_steps_idx', unique: true)
    end

    add_foreign_key('use_case_steps_products', 'use_case_steps', name: 'use_case_steps_products_step_fk')
    add_foreign_key('use_case_steps_products', 'products', name: 'use_case_steps_products_product_fk')
  end
end
