# frozen_string_literal: true

class UpdateCommentObjectType < ActiveRecord::Migration[5.2]
  # https://stackoverflow.com/a/41001595
  disable_ddl_transaction!

  def up
    execute("ALTER TYPE comment_object_type ADD VALUE 'ORGANIZATION';")
    execute("ALTER TYPE comment_object_type RENAME VALUE 'DATASET' TO 'OPEN_DATA';")
  end

  def down
    execute("DELETE FROM pg_enum WHERE enumlabel = 'ORGANIZATION' AND enumtypid = " \
      "(SELECT oid FROM pg_type WHERE typname = 'comment_object_type');")
    execute("ALTER TYPE comment_object_type RENAME VALUE 'OPEN_DATA' to 'DATASET';")
  end
end
