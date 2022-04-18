# frozen_string_literal: true

class AddOrgType < ActiveRecord::Migration[5.1]
  def up
    execute(<<-DDL)
    CREATE TYPE org_type AS ENUM ('owner', 'maintainer' );
    DDL

    add_column(:organizations_products, :org_type, :org_type, default: 'owner')
  end

  def down
    remove_column(:organizations_products, :org_type)

    execute(<<-DDL)
    DROP TYPE org_type;
    DDL
  end
end
