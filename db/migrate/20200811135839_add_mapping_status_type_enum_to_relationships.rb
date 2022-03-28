# frozen_string_literal: true

class AddMappingStatusTypeEnumToRelationships < ActiveRecord::Migration[5.2]
  def up
    execute("CREATE TYPE mapping_status_type AS ENUM ('BETA', 'MATURE', 'SELF-REPORTED', 'VALIDATED');")
  end

  def down
    execute('DROP type mapping_status_type;')
  end
end
