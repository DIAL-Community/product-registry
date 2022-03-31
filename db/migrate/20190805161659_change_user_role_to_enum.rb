# frozen_string_literal: true

class ChangeUserRoleToEnum < ActiveRecord::Migration[5.1]
  def up
    execute 'ALTER TABLE users ALTER role DROP DEFAULT;'

    execute <<-DDL
    CREATE TYPE user_role AS ENUM ('admin', 'ict4sdg', 'principle', 'user' );
    DDL

    change_column :users, :role,\
                  ' user_role USING '\
                  ' (CASE role '\
                  "    WHEN 0 THEN 'admin'::user_role "\
                  "    WHEN 1 THEN 'ict4sdg'::user_role "\
                  "    WHEN 2 THEN 'principle'::user_role "\
                  "    WHEN 3 THEN 'user'::user_role "\
                  ' END)', null: false, default: 'user'
  end

  def down
    execute 'ALTER TABLE users ALTER role DROP DEFAULT;'
    change_column :users, :role,\
                  ' integer USING '\
                  ' (CASE role '\
                  "    WHEN 'admin' THEN 0 "\
                  "    WHEN 'ict4sdg' THEN 1 "\
                  "    WHEN 'principle' THEN 2 "\
                  "    WHEN 'user' THEN 3 "\
                  ' END)', null: false, default: 3
    execute 'DROP TYPE user_role;'
  end
end
