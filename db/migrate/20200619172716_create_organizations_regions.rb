# frozen_string_literal: true

class CreateOrganizationsRegions < ActiveRecord::Migration[5.2]
  def change
    create_table(:organizations_states) do |t|
      t.references(:organization, foreign_key: true, null: false)
      t.references(:region, foreign_key: true, null: false)
    end
  end
end
