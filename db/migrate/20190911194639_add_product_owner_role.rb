# frozen_string_literal: true

class AddProductOwnerRole < ActiveRecord::Migration[5.1]
  def up
    execute(<<-SQL)
      ALTER TABLE users ALTER role DROP DEFAULT;
      ALTER TYPE user_role rename TO user_role_;
      CREATE TYPE user_role AS ENUM ('admin', 'ict4sdg', 'principle', 'user', 'org_user', 'org_product_user', 'product_user');
      ALTER TABLE users ALTER COLUMN role TYPE user_role USING role::text::user_role;
      ALTER TABLE users ALTER COLUMN role SET DEFAULT 'user';
      DROP TYPE user_role_;
    SQL
  end

  def down
    execute(<<-SQL)
    ALTER TABLE users ALTER role DROP DEFAULT;
    ALTER TYPE user_role rename TO user_role_;
    CREATE TYPE user_role AS ENUM ('admin', 'ict4sdg', 'principle', 'user', 'org_user');
    ALTER TABLE users ALTER COLUMN role TYPE user_role USING role::text::user_role;
    ALTER TABLE users ALTER COLUMN role SET DEFAULT 'user';
    DROP TYPE user_role_;
    SQL
  end
end
