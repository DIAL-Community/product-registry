class CreateTableProjectsCountries < ActiveRecord::Migration[5.2]
  def change
    create_table :projects_countries do |t|
      t.references :project, foreign_key: true, null: false
      t.references :country, foreign_key: true, null: false
    end
  end
end
