class AddMoreUserRoleEnum < ActiveRecord::Migration[5.2]
  def up
    execute("ALTER TYPE user_role ADD VALUE 'content_writer';")
    execute("ALTER TYPE user_role ADD VALUE 'content_editor';")
  end

  def down
    execute("ALTER TYPE user_role DROP VALUE 'content_writer';")
    execute("ALTER TYPE user_role DROP VALUE 'content_editor';")
  end
end
