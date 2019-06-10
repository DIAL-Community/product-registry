class CreateWorkflows < ActiveRecord::Migration[5.1]
  def change
    create_table :workflows do |t|
      t.string :name
      t.string :slug
      t.string :description
      t.string :other_names
      t.string :category

      t.timestamps
    end
    create_table "workflows_building_blocks", id: false, force: :cascade do |t|
      t.bigint "workflow_id", null: false
      t.bigint "building_block_id", null: false
      t.index ["workflow_id", "building_block_id"], name: "workflows_bbs", unique: true
      t.index ["building_block_id", "workflow_id"], name: "bbs_workflows", unique: true
    end

    add_foreign_key "workflows_building_blocks", "workflows", name: "workflows_bbs_workflow_fk"
    add_foreign_key "workflows_building_blocks", "building_blocks", name: "workflows_bbs_bb_fk"

    create_table "workflows_use_cases", id: false, force: :cascade do |t|
      t.bigint "workflow_id", null: false
      t.bigint "use_case_id", null: false
      t.index ["workflow_id", "use_case_id"], name: "workflows_usecases", unique: true
      t.index ["use_case_id", "workflow_id"], name: "usecases_workflows", unique: true
    end

    add_foreign_key "workflows_use_cases", "workflows", name: "workflows_usecases_workflow_fk"
    add_foreign_key "workflows_use_cases", "use_cases", name: "workflows_usecases_usecase_fk"
  end
end
