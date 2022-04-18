# frozen_string_literal: true

class AddLogoToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column(:products, :logo, :string, null: true)
  end
end
