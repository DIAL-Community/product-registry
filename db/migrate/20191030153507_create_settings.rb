class CreateSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :settings do |t|
      t.string :name, null: false
      t.string :slug, unique: true, null: false
      t.string :description, null: false
      t.text :value, null: false

      t.timestamps
    end
  end
end
