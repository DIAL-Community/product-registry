# frozen_string_literal: true

class AddAliasesToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :aliases, :string, array: true, default: []
  end
end
