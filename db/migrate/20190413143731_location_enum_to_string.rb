# frozen_string_literal: true

class LocationEnumToString < ActiveRecord::Migration[5.1]
  def up
    execute ''\
      'alter table locations add column location_type_string varchar(16);'\
      "update locations set location_type_string = 'point' where location_type = 0;"\
      "update locations set location_type_string = 'country' where location_type = 1;"\
      'alter table locations drop column location_type;'\
      'alter table locations rename column location_type_string to location_type;'\
    ''
  end

  def down
    execute ''\
      'alter table locations add column location_type_int integer;'\
      "update locations set location_type_int = 0 where location_type = 'point';"\
      "update locations set location_type_int = 1 where location_type = 'country';"\
      'alter table locations drop column location_type;'\
      'alter table locations rename column location_type_int to location_type;'\
    ''
  end
end
