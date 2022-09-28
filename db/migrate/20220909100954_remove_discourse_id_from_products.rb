# frozen_string_literal: true

class RemoveDiscourseIdFromProducts < ActiveRecord::Migration[5.2]
  def change
    if ActiveRecord::Base.connection.column_exists?(:products, :discourse_id)
      remove_column(:products, :discourse_id, :int8)
    end
  end
end
