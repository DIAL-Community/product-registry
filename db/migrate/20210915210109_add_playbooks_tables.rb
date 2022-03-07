class AddPlaybooksTables < ActiveRecord::Migration[5.2]
  def change

    create_table :plays do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :author
      t.jsonb :resources, null: false, default: [] # External URLs and documents that can be referenced
      t.string :tags, array: true, default: []
      t.string :version, null: false, default: "1.0"

      t.timestamps
    end

    create_table :play_descriptions do |t|
      t.references :play, foreign_key: true
      t.string :locale, null: false
      t.string :description, null: false
    end

    create_table :play_moves do |t|
      t.references :play, foreign_key: true
      t.string :name, null: false
      t.string :slug, null: false
      t.integer :order, null: false
      t.jsonb :resources, null: false, default: [] # External URLs and documents that can be referenced

      t.timestamps
    end

    create_table :move_descriptions do |t|
      t.references :play_move, foreign_key: true
      t.string :locale, null: false
      t.string :description, null: false
      t.string :prerequisites, null: false, default: ''
      t.string :outcomes, null: false, default: ''
    end

    create_table :plays_products do |t|
      t.references :play, foreign_key: true
      t.references :product, foreign_key: true
      t.index ['product_id', 'play_id'], name: 'products_plays_idx', unique: true
      t.index ['play_id', 'product_id'], name: 'plays_products_idx', unique: true
    end
    add_foreign_key 'plays_products', 'products', name: 'products_plays_product_fk'
    add_foreign_key 'plays_products', 'plays', name: 'products_plays_play_fk'

    create_table :plays_building_blocks do |t|
      t.references :play, foreign_key: true
      t.references :building_block, foreign_key: true
      t.index ['building_block_id', 'play_id'], name: 'bbs_plays_idx', unique: true
      t.index ['play_id', 'building_block_id'], name: 'plays_bbs_idx', unique: true
    end
    add_foreign_key 'plays_building_blocks', 'building_blocks', name: 'bbs_plays_bb_fk'
    add_foreign_key 'plays_building_blocks', 'plays', name: 'bbs_plays_play_fk'

    create_table :plays_subplays do |t|
      t.bigint :parent_play_id, null: false
      t.bigint :child_play_id, null: false
      t.integer :order
      t.index ["parent_play_id", "child_play_id"], name: "play_rel_index", unique: true
    end
    add_foreign_key :plays_subplays, :plays, column: :parent_play_id, name: 'parent_play_fk'
    add_foreign_key :plays_subplays, :plays, column: :child_play_id, name: 'child_play_fk'

    create_table :playbooks do |t|
      t.string :name, null: false
      t.string :slug, unique: true, null: false
      t.jsonb :phases, null: false, default: []
      t.string :tags, array: true, default: []
      t.timestamps
    end

    create_table :playbook_descriptions do |t|
      t.references :playbook, foreign_key: true
      t.string :locale, null: false
      t.string :overview, null: false
      t.string :audience, null: false
      t.string :outcomes, null: false
    end

    create_table :playbook_plays do |t|
      t.references :playbook, foreign_key: true, null: false
      t.references :play, foreign_key: true, null: false
      t.string :phase
      t.integer :order
    end

    create_table "playbooks_sectors", id: false, force: :cascade do |t|
      t.bigint "playbook_id", null: false
      t.bigint "sector_id", null: false
      t.index ["playbook_id", "sector_id"], name: "playbooks_sectors_idx", unique: true
      t.index ["sector_id", "playbook_id"], name: "sectors_playbooks_idx", unique: true
    end

    add_foreign_key "playbooks_sectors", "playbooks", name: "playbooks_sectors_playbook_fk"
    add_foreign_key "playbooks_sectors", "sectors", name: "playbooks_sectors_sector_fk"
  end
end
