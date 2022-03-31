# frozen_string_literal: true

class ChangeProductsSectorsToProductSectors < ActiveRecord::Migration[5.2]
  def change
    rename_table(:products_sectors, :product_sectors)
  end
end
