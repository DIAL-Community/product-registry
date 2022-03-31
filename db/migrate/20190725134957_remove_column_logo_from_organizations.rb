# frozen_string_literal: true

class RemoveColumnLogoFromOrganizations < ActiveRecord::Migration[5.1]
  def change
    remove_column :organizations, :logo
  end
end
