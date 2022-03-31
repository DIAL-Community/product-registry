# frozen_string_literal: true

class AddLevelToEndorsers < ActiveRecord::Migration[5.2]
  def up
    execute <<-DDL
    CREATE TYPE endorser_type AS ENUM ('none', 'bronze', 'silver', 'gold');
    DDL

    add_column :organizations, :endorser_level, :endorser_type, default: 'none'
  end

  def down
    remove_column :organizations, :endorser_level

    execute <<-DDL
    DROP type endorser_type;
    DDL
  end
end
