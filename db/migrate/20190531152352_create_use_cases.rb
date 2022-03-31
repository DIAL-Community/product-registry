# frozen_string_literal: true

class CreateUseCases < ActiveRecord::Migration[5.1]
  def change
    create_table :use_cases do |t|
      t.string :name
      t.string :slug
      t.string :description
      t.references :sector, foreign_key: true

      t.timestamps
    end
  end
end
