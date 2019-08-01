class AddColumnTypeToLocations < ActiveRecord::Migration[5.1]
  def up
    execute <<-DDL
    CREATE TYPE location_type AS ENUM (
      'country', 'point'
    );
    DDL

    add_column :locations, :type_of_location, :location_type
  end

  def down
    remove_column :locations, :type_of_location
    execute "DROP type location_type;"
  end
end
