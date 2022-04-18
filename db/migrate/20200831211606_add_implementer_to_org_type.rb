# frozen_string_literal: true

class AddImplementerToOrgType < ActiveRecord::Migration[5.2]
  def up
    execute(<<-DDL)
    ALTER TYPE org_type RENAME TO org_type_save;
    CREATE TYPE org_type AS ENUM ('owner', 'maintainer', 'funder', 'implementer');
    ALTER TYPE product_type RENAME TO product_type_save;
    CREATE TYPE product_type AS ENUM ('product', 'dataset', 'content' );
    DDL
  end

  def down
    execute(<<-DDL)
    ALTER TYPE org_type RENAME TO org_type_new;
    CREATE TYPE org_type AS ENUM ('owner', 'maintainer', 'funder');
    ALTER TYPE product_type RENAME TO product_type_new;
    CREATE TYPE product_type AS ENUM ('product', 'dataset' );
    DDL
  end
end
