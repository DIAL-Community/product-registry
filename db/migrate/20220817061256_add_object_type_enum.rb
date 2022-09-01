# frozen_string_literal: true

class AddObjectTypeEnum < ActiveRecord::Migration[5.2]
  def up
    execute("CREATE TYPE comment_object_type AS " \
    "ENUM ('PRODUCT','DATASET','PROJECT','USE_CASE','BUILDING_BLOCK','PLAYBOOK');")
  end

  def down
    execute('DROP type comment_object_type;')
  end
end
