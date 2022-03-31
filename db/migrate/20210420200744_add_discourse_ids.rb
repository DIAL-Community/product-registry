# frozen_string_literal: true

class AddDiscourseIds < ActiveRecord::Migration[5.2]
  def change
    add_column(:products, :discourse_id, :bigint, null: true)
    add_column(:building_blocks, :discourse_id, :bigint, null: true)

    add_column(:users, :username, :string, null: true)
  end
end
