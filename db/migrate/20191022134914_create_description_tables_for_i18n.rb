# frozen_string_literal: true

class CreateDescriptionTablesForI18n < ActiveRecord::Migration[5.1]
  def change
    create_table :use_case_descriptions do |t|
      t.references :use_case, foreign_key: true
      t.string :locale, null: false
      t.jsonb :description, null: false, default: '{}'
    end

    create_table :workflow_descriptions do |t|
      t.references :workflow, foreign_key: true
      t.string :locale, null: false
      t.jsonb :description, null: false, default: '{}'
    end

    create_table :building_block_descriptions do |t|
      t.references :building_block, foreign_key: true
      t.string :locale, null: false
      t.jsonb :description, null: false, default: '{}'
    end
  end
end
