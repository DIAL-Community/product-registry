# frozen_string_literal: true

class AddMaturityToBbAndMappings < ActiveRecord::Migration[5.2]
  def change
    add_column :building_blocks, :maturity, :string, default: 'Beta'
    add_column :playbooks, :maturity, :string, default: 'Beta'
    add_column :products, :status, :string

    add_column :products_building_blocks, :link_type, :string, default: 'Beta'
  end
end
