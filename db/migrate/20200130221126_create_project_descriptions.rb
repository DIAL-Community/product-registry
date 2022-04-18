# frozen_string_literal: true

class CreateProjectDescriptions < ActiveRecord::Migration[5.1]
  def change
    create_table(:project_descriptions) do |t|
      t.references(:project, foreign_key: true)
      t.string(:locale, null: false)
      t.jsonb(:description, null: false, default: '{}')

      t.timestamps
    end
  end
end
