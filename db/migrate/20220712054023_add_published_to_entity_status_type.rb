# frozen_string_literal: true
class AddPublishedToEntityStatusType < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def up
    execute("ALTER TYPE entity_status_type ADD VALUE 'PUBLISHED';")
  end

  def down
    execute("DELETE FROM pg_enum WHERE enumlabel = 'PUBLISHED' AND enumtypid = " \
      "(SELECT oid FROM pg_type WHERE typname = 'entity_status_type');")
  end
end
