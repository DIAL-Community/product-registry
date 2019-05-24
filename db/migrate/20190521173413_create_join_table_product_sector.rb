class CreateJoinTableProductSector < ActiveRecord::Migration[5.1]
  def change
    create_join_table :products, :sectors do |t|
      t.index [:product_id, :sector_id]
      t.index [:sector_id, :product_id]
    end
  end
end
