class AddPublicgoodsDataToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column(:products, :publicgoods_data, :jsonb, null: false, default: {})
  end
end
