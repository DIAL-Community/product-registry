# frozen_string_literal: true

class CreateTableOrganizationDescriptions < ActiveRecord::Migration[5.1]
  def change
    create_table(:organization_descriptions) do |t|
      t.references(:organization, foreign_key: true)
      t.string(:locale, null: false)
      t.jsonb(:description, null: false, default: '{}')

      t.timestamps
    end
  end
end
