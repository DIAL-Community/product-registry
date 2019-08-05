class ChangeProductRelationshipToEnum < ActiveRecord::Migration[5.1]
  def up
    execute <<-DDL
    CREATE TYPE relationship_type AS ENUM ('composed', 'interoperates');
    DDL

    change_column :product_product_relationships, :relationship_type, "relationship_type USING (CASE relationship_type WHEN 'composed' THEN 'composed'::relationship_type WHEN 'interoperates' THEN 'interoperates'::relationship_type END)", null: false
  end

  def down
    change_column :product_product_relationships, :relationship_type, "varchar(16) USING (CASE relationship_type WHEN 'composed' THEN 'composed' WHEN 'interoperates' THEN 'interoperates' END)", null: false
    execute "DROP TYPE relationship_type;"
  end
end
