# frozen_string_literal: true

class AddMigratedAndDateToProjectsLocations < ActiveRecord::Migration[5.2]
  def change
    add_column(:projects_locations, :id, :primary_key)
    add_column(:projects_locations, :migrated, :boolean)
    add_column(:projects_locations, :migrated_date, :datetime)
  end
end
