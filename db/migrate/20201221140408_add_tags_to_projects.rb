# frozen_string_literal: true

class AddTagsToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column(:projects, :tags, :string, array: true, default: [])
  end
end
