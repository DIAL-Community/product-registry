# frozen_string_literal: true

class AddIsDisplayableToSectors < ActiveRecord::Migration[5.1]
  def change
    add_column :sectors, :is_displayable, :boolean
  end
end
