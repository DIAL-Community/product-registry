# frozen_string_literal: true

class CreateJoinTableProductSector < ActiveRecord::Migration[5.1]
  def change
    create_join_table :products, :sectors do |t|
      t.index %i[product_id sector_id]
      t.index %i[sector_id product_id]
    end
  end
end
