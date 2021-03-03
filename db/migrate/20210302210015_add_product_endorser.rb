class AddProductEndorser < ActiveRecord::Migration[5.2]
  def change
    remove_column(:products, :status, :string)

    create_table :endorsers do |t|
      t.string :slug, null: false
      t.string :name, null: false
      t.string :description
    end

    create_table :products_endorsers do |t|
      t.references :product, foreign_key: true, null: false
      t.references :endorser, foreign_key: true, null: false
    end
  end
end
