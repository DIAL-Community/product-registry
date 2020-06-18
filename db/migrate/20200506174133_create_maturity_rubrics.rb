class CreateMaturityRubrics < ActiveRecord::Migration[5.2]
  def change
    create_table :maturity_rubrics do |t|
      t.string :name, null: false
      t.string :slug, unique: true, null: false

      t.timestamps
    end
  end
end
