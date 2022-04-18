# frozen_string_literal: true

class CreatePlaybookPage < ActiveRecord::Migration[5.2]
  def change
    create_table(:playbook_pages) do |t|
      t.references(:playbook, foreign_key: true, null: false)
      t.string(:name, null: false)
      t.string(:slug, null: false)
      t.string(:phase)
      t.integer(:order)
      t.references(:playbook_questions, foreign_key: true)
      t.jsonb(:resources, null: false, default: []) # External URLs and documents that can be referenced
      t.string(:media_url)
    end

    create_table(:page_contents) do |t|
      t.references(:playbook_page, foreign_key: true)
      t.string(:locale, null: false)
      t.jsonb(:contents, null: false, default: {})
      t.integer(:order)
      t.string(:placement) # left sidebar, right sidebar, float left, float right
      t.jsonb(:popover, null: false, default: {})
    end
  end
end
