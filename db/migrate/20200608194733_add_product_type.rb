class AddProductType < ActiveRecord::Migration[5.2]
  def up

    execute <<-DDL
    CREATE TYPE product_type AS ENUM ('product', 'dataset' );
    DDL

    add_column :products, :product_type, :product_type, :default => 'product'
  end

  def down

    remove_column :products, :product_type

    execute <<-DDL
    DROP TYPE product_type;
    DDL
  end
end
