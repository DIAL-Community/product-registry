# frozen_string_literal: true

class RemoveDescriptionFromProjects < ActiveRecord::Migration[5.1]
  def change
    remove_column :projects, :description, :string
  end
end
