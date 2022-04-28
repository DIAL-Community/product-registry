# frozen_string_literal: true
class AddSpecUrlToBb < ActiveRecord::Migration[5.2]
  def change
    add_column(:building_blocks, :spec_url, :string)
  end
end
