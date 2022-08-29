# frozen_string_literal: true

class UpdateCommentObjectType < ActiveRecord::Migration[5.2]
  # https://stackoverflow.com/a/41001595
  disable_ddl_transaction!

  def up
    execute("ALTER TYPE comment_object_type ADD VALUE 'ORGANIZATION';")
    execute("ALTER TYPE comment_object_type RENAME VALUE 'DATASET' TO 'OPEN_DATA';")
  end

  def down
    execute("ALTER TYPE comment_object_type DROP VALUE 'ORGANIZATION';")
    execute("ALTER TYPE comment_object_type DROP VALUE 'OPEN_DATA';")
  end
end
