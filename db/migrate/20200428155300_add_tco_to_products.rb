# frozen_string_literal: true

class AddTcoToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :code_lines, :integer
    add_column :products, :cocomo, :integer
    add_column :products, :est_hosting, :integer
    add_column :products, :est_invested, :integer
  end
end
