# frozen_string_literal: true

class CreateEntityStatusTypeEnum < ActiveRecord::Migration[5.2]
  def up
    execute("CREATE TYPE entity_status_type AS ENUM ('BETA', 'MATURE', 'SELF-REPORTED', 'VALIDATED');")
  end

  def down
    execute('DROP type entity_status_type;')
  end
end
