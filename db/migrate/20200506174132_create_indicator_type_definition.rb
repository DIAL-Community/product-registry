# frozen_string_literal: true

class CreateIndicatorTypeDefinition < ActiveRecord::Migration[5.2]
  def up
    execute(<<-DDL)
      CREATE TYPE category_indicator_type AS ENUM ('boolean', 'scale', 'numeric');
    DDL
  end

  def down
    execute('DROP type category_indicator_type;')
  end
end
