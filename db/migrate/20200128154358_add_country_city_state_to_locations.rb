# frozen_string_literal: true

class AddCountryCityStateToLocations < ActiveRecord::Migration[5.1]
  def change
    add_column(:locations, :country, :string)
    add_column(:locations, :city, :string)
    add_column(:locations, :state, :string)
  end
end
