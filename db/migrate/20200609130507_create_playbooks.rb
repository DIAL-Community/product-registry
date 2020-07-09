class CreatePlaybooks < ActiveRecord::Migration[5.2]
  def change

    create_table :digital_principles do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :url, null: false
    end

    create_table :principle_descriptions do |t|
      t.references :digital_principle, foreign_key: true
      t.string :locale, null: false
      t.jsonb :description, null: false, default: {}
    end

    create_table :tasks do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :description
      t.boolean :complete, default: false
      t.date :due_date
      t.jsonb :resources, null: false, default: [] # External URLs and documents that can be referenced

      t.timestamps
    end

    create_table :task_descriptions do |t|
      t.references :task, foreign_key: true
      t.string :locale, null: false
      t.jsonb :description, null: false, default: {}
      t.jsonb :prerequisites, null: false, default: {}
      t.jsonb :outcomes, null: false, default: {}
    end

    create_table :tasks_organizations do |t|
      t.bigint 'task_id', null: false
      t.bigint 'organization_id', null: false
      t.index ['organization_id', 'task_id'], name: 'organizations_plays_idx', unique: true
      t.index ['task_id', 'organization_id'], name: 'plays_organizations_idx', unique: true
    end
    add_foreign_key 'tasks_organizations', 'organizations', name: 'organizations_tasks_org_fk'
    add_foreign_key 'tasks_organizations', 'tasks', name: 'organizations_tasks_play_fk'

    create_table :tasks_products do |t|
      t.bigint 'task_id', null: false
      t.bigint 'product_id', null: false
      t.index ['product_id', 'task_id'], name: 'products_tasks_idx', unique: true
      t.index ['task_id', 'product_id'], name: 'tasks_products_idx', unique: true
    end
    add_foreign_key 'tasks_products', 'products', name: 'products_tasks_product_fk'
    add_foreign_key 'tasks_products', 'tasks', name: 'products_tasks_task_fk'

    create_table :plays do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :description
      t.string :author
      t.jsonb :resources, null: false, default: [] # External URLs and documents that can be referenced

      t.string :version, null: false, default: "1.0"

      t.timestamps
    end

    create_table :plays_tasks do |t|
      t.bigint 'play_id', null: false
      t.bigint 'task_id', null: false
      t.index ['task_id', 'play_id'], name: 'tasks_plays_idx', unique: true
      t.index ['play_id', 'task_id'], name: 'plays_tasks_idx', unique: true
    end
    add_foreign_key 'plays_tasks', 'tasks', name: 'tasks_plays_task_fk'
    add_foreign_key 'plays_tasks', 'plays', name: 'tasks_plays_play_fk'

    create_table :plays_subplays do |t|
      t.bigint :parent_play_id, null: false
      t.bigint :child_play_id, null: false
      t.index ["parent_play_id", "child_play_id"], name: "play_rel_index", unique: true
    end
    add_foreign_key :plays_subplays, :plays, column: :parent_play_id, name: 'parent_play_fk'
    add_foreign_key :plays_subplays, :plays, column: :child_play_id, name: 'child_play_fk'

    create_table :playbooks do |t|
      t.string :name, null: false
      t.string :slug, unique: true, null: false
      t.jsonb :phases, null: false, default: []
      t.timestamps
    end

    create_table :playbook_descriptions do |t|
      t.references :playbook, foreign_key: true
      t.string :locale, null: false
      t.jsonb :overview, null: false, default: {}
      t.jsonb :audience, null: false, default: {}
      t.jsonb :outcomes, null: false, default: {}
    end

    create_table :activities do |t|
      t.references :playbook, foreign_key: true, null: false
      t.string :name, null: false
      t.string :slug, null: false
      t.string :description
      t.string :phase
      t.jsonb :resources, null: false, default: [] # External URLs and documents that can be referenced
    end

    create_table :activities_principles do |t|
      t.bigint 'activity_id', null: false
      t.bigint 'digital_principle_id', null: false
      t.index ['digital_principle_id', 'activity_id'], name: 'principles_activities_idx', unique: true
      t.index ['activity_id', 'digital_principle_id'], name: 'activities_principles_idx', unique: true
    end
    add_foreign_key 'activities_principles', 'digital_principles', name: 'principles_activities_principle_fk'
    add_foreign_key 'activities_principles', 'activities', name: 'principles_activities_phase_fk'

    create_table :activities_tasks do |t|
      t.bigint :activity_id, null: false
      t.bigint :task_id, null: false
      t.index ['task_id', 'activity_id'], name: 'tasks_activities_idx', unique: true
      t.index ['activity_id', 'task_id'], name: 'activities_tasks_idx', unique: true
    end
    add_foreign_key :activities_tasks, 'activities', name: 'activities_tasks_activity_fk'
    add_foreign_key :activities_tasks, 'tasks', name: 'activities_tasks_task_fk'

  end
end
