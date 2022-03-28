# frozen_string_literal: true

class AddResourcesTable < ActiveRecord::Migration[5.2]
  def change
    create_table :resources do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :phase, null: false
      t.string :image_url, null: true
      t.string :link, null: true
      t.string :description, null: true
    end
  end
end
