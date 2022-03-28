# frozen_string_literal: true

class CreatePortalViews < ActiveRecord::Migration[5.1]
  def change
    create_table :portal_views do |t|
      t.string :name
      t.string :slug, null: false
      t.string :description
      t.string :top_navs, default: [], array: true
      t.string :filter_navs, default: [], array: true
      t.string :user_roles, default: [], array: true
      t.string :product_views, default: [], array: true
      t.string :organization_views, default: [], array: true
      t.string :subdomain

      t.timestamps
    end
  end
end
