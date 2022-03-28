# frozen_string_literal: true

class AddChildRelationshipToProducts < ActiveRecord::Migration[5.1]
  def up
    execute <<-DDL
    ALTER TYPE org_type RENAME TO org_type_orig;
    CREATE TYPE org_type AS ENUM ('owner', 'maintainer', 'funder');
    DDL

    add_column :products, :is_child, :boolean, default: false
    add_column :products, :parent_product_id, :integer
  end

  def down
    remove_column :products, :is_child
    remove_column :products, :parent_product_id

    execute <<-DDL
    ALTER TYPE org_type RENAME TO org_type_orig;
    CREATE TYPE org_type AS ENUM ('owner', 'maintainer');
    DDL
  end
end
