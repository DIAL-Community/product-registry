# frozen_string_literal: true

class AddContentToBbAndWorkflows < ActiveRecord::Migration[5.1]
  def change
    remove_column(:workflows, :description, :string)
    remove_column(:workflows, :other_names, :string)
    remove_column(:workflows, :category, :string)

    add_column(:workflows, :description, :jsonb, null: false, default: '{}')

    add_column(:building_blocks, :description, :jsonb, null: false, default: '{}')
  end
end
