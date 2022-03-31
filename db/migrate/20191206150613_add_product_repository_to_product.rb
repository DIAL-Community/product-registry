# frozen_string_literal: true

class AddProductRepositoryToProduct < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :repository, :string
  end
end
