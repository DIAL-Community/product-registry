# frozen_string_literal: true

class AddAliasesToLocations < ActiveRecord::Migration[5.1]
  def change
    add_column(:locations, :aliases, :string, array: true, default: [])
  end
end
