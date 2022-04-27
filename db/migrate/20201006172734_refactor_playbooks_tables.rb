# frozen_string_literal: true

class RefactorPlaybooksTables < ActiveRecord::Migration[5.2]
  def change
    drop_table(:activity_descriptions)
    drop_table(:activities_tasks)
    drop_table(:activities_principles)
    drop_table(:activities)

    drop_table(:plays_subplays)
    drop_table(:plays_tasks)
    drop_table(:plays)

    drop_table(:task_descriptions)
    drop_table(:tasks_organizations)
    drop_table(:tasks_products)
    drop_table(:tasks)

    drop_table(:playbook_pages, force: :cascade)
    drop_table(:page_contents, force: :cascade)

    create_table(:playbook_pages) do |t|
      t.references(:playbook, foreign_key: true, null: false)
      t.string(:name, null: false)
      t.string(:slug, null: false)
      t.string(:phase)
      t.integer(:page_order)
      t.references(:parent_page, foreign_key: { to_table: :playbook_pages })
      t.references(:playbook_questions, foreign_key: true)
      t.jsonb(:resources, null: false, default: []) # External URLs and documents that can be referenced
      t.string(:media_url)
    end

    create_table(:page_contents) do |t|
      t.references(:playbook_page, foreign_key: true)
      t.string(:locale, null: false)
      t.string(:html, null: false)
      t.string(:css, null: false)
      t.string(:components)
      t.string(:assets)
      t.string(:styles)
      t.string(:editor_type)
    end
  end
end
