# frozen_string_literal: true

class RemoveDiscourseIdFromBuildingBlocks < ActiveRecord::Migration[5.2]
  def change
    if ActiveRecord::Base.connection.column_exists?(:building_blocks, :discourse_id)
      remove_column(:building_blocks, :discourse_id, :int8)
    end
  end
end
