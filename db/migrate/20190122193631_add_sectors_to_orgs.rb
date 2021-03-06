class AddSectorsToOrgs < ActiveRecord::Migration[5.1]
  def change
    create_table "organizations_sectors", id: false, force: :cascade do |t| 
      t.bigint "sector_id", null: false
      t.bigint "organization_id", null: false
      t.index ["sector_id", "organization_id"], name: "sector_orcs"
      t.index ["organization_id", "sector_id"], name: "org_sectors"
    end 
  end
end
