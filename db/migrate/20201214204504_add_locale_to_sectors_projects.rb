# frozen_string_literal: true

class AddLocaleToSectorsProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :sectors, :locale, :string, default: 'en'

    remove_index :sectors, %i[slug origin_id parent_sector_id]
    add_index :sectors, %i[slug origin_id parent_sector_id locale], unique: true, name: 'index_sector_slug_unique'

    create_table :projects_digital_principles do |t|
      t.references :project, foreign_key: true, null: false
      t.references :digital_principle, foreign_key: true, null: false
    end
  end
end
