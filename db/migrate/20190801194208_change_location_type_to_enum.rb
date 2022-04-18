# frozen_string_literal: true

class ChangeLocationTypeToEnum < ActiveRecord::Migration[5.1]
  def up
    execute(<<-DDL)
    CREATE TYPE location_type AS ENUM ('country', 'point');
    DDL

    change_column(:locations, :location_type,
                  "location_type USING " \
                  " (CASE location_type " \
                  "  WHEN 'point' THEN 'point'::location_type " \
                  "  WHEN 'country' THEN 'country'::location_type END)",
                  null: false)
  end

  def down
    change_column(:locations, :location_type,
                  "varchar(16) USING " \
                  " (CASE location_type "\
                  "  WHEN 'point' THEN 'point' "\
                  "  WHEN 'country' THEN 'country' END)",
                  null: false)
    execute('DROP type location_type;')
  end
end
