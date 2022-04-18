# frozen_string_literal: true

class CreatePortalViewEnums < ActiveRecord::Migration[5.1]
  def up
    execute(<<-DDL)
    CREATE TYPE top_nav AS ENUM ('sdgs', 'use_cases', 'workflows', 'building_blocks', 'products', 'projects', 'organizations');
    CREATE TYPE filter_nav AS ENUM ('sdgs', 'use_cases', 'workflows', 'building_blocks', 'products', 'projects', 'locations',
                                    'sectors', 'organizations');
    DDL
  end

  def down
    execute(<<-DDL)
    DROP type top_nav;
    DROP type filter_nav;
    DDL
  end
end
