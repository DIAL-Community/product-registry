# frozen_string_literal: true
class AddPublishedToEntityStatusType < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def up
    execute("ALTER TYPE entity_status_type ADD VALUE 'PUBLISHED';")
  end

  def down
    execute("ALTER TYPE entity_status_type DROP VALUE 'PUBLISHED';")
  end
end
