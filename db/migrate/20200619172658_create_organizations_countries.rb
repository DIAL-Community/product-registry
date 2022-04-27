# frozen_string_literal: true

class CreateOrganizationsCountries < ActiveRecord::Migration[5.2]
  def change
    create_table(:organizations_countries) do |t|
      t.references(:organization, foreign_key: true, null: false)
      t.references(:country, foreign_key: true, null: false)
    end
  end
end
