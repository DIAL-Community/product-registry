# frozen_string_literal: true

class AddLogoToOrganizations < ActiveRecord::Migration[5.1]
  def change
    add_column(:organizations, :logo, :string, null: true)
  end
end
