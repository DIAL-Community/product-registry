class UpdatePlaybooks < ActiveRecord::Migration[5.2]
  def up
    #drop_table :plays_subplays

    create_table :activity_descriptions do |t|
      t.references :activity, foreign_key: true
      t.string :locale, null: false
      t.string :description, null: false, default: ""
    end

    change_column :principle_descriptions, :description, :string, default: ""
    change_column :task_descriptions, :description, :string, default: ""
    change_column :task_descriptions, :prerequisites, :string, default: ""
    change_column :task_descriptions, :outcomes, :string, default: ""

    change_column :playbook_descriptions, :overview, :string, default: ""
    change_column :playbook_descriptions, :audience, :string, default: ""
    change_column :playbook_descriptions, :outcomes, :string, default: ""
  end

  def down
    #drop_table :activity_descriptions

    remove_column :principle_descriptions, :description
    add_column :principle_descriptions, :description, :jsonb, default: {}

    remove_column :task_descriptions, :description
    add_column :task_descriptions, :description, :jsonb, default: {}
    remove_column :task_descriptions, :prerequisites
    add_column :task_descriptions, :prerequisites, :jsonb, default: {}
    remove_column :task_descriptions, :outcomes
    add_column :task_descriptions, :outcomes, :jsonb, default: {}

    remove_column :playbook_descriptions, :overview
    add_column :playbook_descriptions, :overview, :jsonb, default: {}
    remove_column :playbook_descriptions, :audience
    add_column :playbook_descriptions, :audience, :jsonb, default: {}
    remove_column :playbook_descriptions, :outcomes
    add_column :playbook_descriptions, :outcomes, :jsonb, default: {}
  end
end
