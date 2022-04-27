# frozen_string_literal: true

class CreateProductDescriptions < ActiveRecord::Migration[5.1]
  def change
    create_table(:product_descriptions) do |t|
      t.references(:product, foreign_key: true)
      t.string(:locale, null: false)
      t.jsonb(:description, null: false, default: '{}')

      t.timestamps
    end
  end
end
