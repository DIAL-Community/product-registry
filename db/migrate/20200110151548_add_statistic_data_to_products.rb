class AddStatisticDataToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :statistics, :jsonb, null: false, default: '{}'
  end
end
