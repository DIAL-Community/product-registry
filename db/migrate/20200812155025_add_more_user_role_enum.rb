# frozen_string_literal: true

class AddMoreUserRoleEnum < ActiveRecord::Migration[5.2]
  # https://stackoverflow.com/a/41001595
  disable_ddl_transaction!

  def up
    execute("ALTER TYPE user_role ADD VALUE 'content_writer';")
    execute("ALTER TYPE user_role ADD VALUE 'content_editor';")
  end

  def down
    execute("ALTER TYPE user_role DROP VALUE 'content_writer';")
    execute("ALTER TYPE user_role DROP VALUE 'content_editor';")
  end
end
