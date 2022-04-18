# frozen_string_literal: true

class AddNameAndDescriptionToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column(:projects, :name, :string, null: false)
    add_column(:projects, :description, :string, null: false)
  end
end
