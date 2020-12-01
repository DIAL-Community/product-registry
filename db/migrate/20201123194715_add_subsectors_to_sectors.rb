class AddSubsectorsToSectors < ActiveRecord::Migration[5.2]
  def change
    change_table :sectors do |t|
      t.references :parent_sector, foreign_key: {to_table: :sectors}
      t.references :origin, foreign_key: {to_table: :origins}
    end

    remove_index :sectors, :slug
    add_index :sectors, [:slug, :origin_id, :parent_sector_id], unique: true
  end
end
