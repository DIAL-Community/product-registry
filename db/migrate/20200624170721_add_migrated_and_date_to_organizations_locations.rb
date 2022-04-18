# frozen_string_literal: true

class AddMigratedAndDateToOrganizationsLocations < ActiveRecord::Migration[5.2]
  def change
    add_column(:organizations_locations, :migrated, :boolean)
    add_column(:organizations_locations, :migrated_date, :datetime)
  end
end
