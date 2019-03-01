class AddTypeToLocations < ActiveRecord::Migration[5.1]
  def change
    add_column :locations, :location_type, :integer
  end
end
