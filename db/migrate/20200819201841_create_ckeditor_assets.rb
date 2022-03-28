# frozen_string_literal: true

class CreateCkeditorAssets < ActiveRecord::Migration[5.2]
  def up
    create_table :ckeditor_assets do |t|
      t.string  :data_file_name, null: false
      t.string  :data_content_type
      t.integer :data_file_size
      t.string  :type, limit: 30

      # Uncomment it to save images dimensions, if your need it
      # t.integer :width
      # t.integer :height

      t.timestamps null: false
    end

    add_index :ckeditor_assets, :type

    change_column :building_block_descriptions, :description, :string, default: ''
    change_column :category_indicator_descriptions, :description, :string, default: ''
    change_column :glossaries, :description, :string, default: ''
    change_column :maturity_rubric_descriptions, :description, :string, default: ''
    change_column :organization_descriptions, :description, :string, default: ''
    change_column :product_descriptions, :description, :string, default: ''
    change_column :project_descriptions, :description, :string, default: ''
    change_column :rubric_category_descriptions, :description, :string, default: ''
    change_column :tag_descriptions, :description, :string, default: ''
    change_column :use_case_descriptions, :description, :string, default: ''
    change_column :use_case_headers, :header, :string, default: ''
    change_column :use_case_step_descriptions, :description, :string, default: ''
    change_column :workflow_descriptions, :description, :string, default: ''
    change_column :stylesheets, :about_page, :string, default: ''
    change_column :stylesheets, :footer_content, :string, default: ''

    remove_column :maturity_rubric_descriptions, :description_html
    remove_column :rubric_category_descriptions, :description_html
    remove_column :category_indicator_descriptions, :description_html
  end

  def down
    drop_table :ckeditor_assets

    remove_column :building_block_descriptions, :description
    add_column :building_block_descriptions, :description, :jsonb, default: {}
    remove_column :category_indicator_descriptions, :description
    add_column :category_indicator_descriptions, :description, :jsonb, default: {}
    remove_column :glossaries, :description
    add_column :glossaries, :description, :jsonb, default: {}
    remove_column :maturity_rubric_descriptions, :description
    add_column :maturity_rubric_descriptions, :description, :jsonb, default: {}
    remove_column :organization_descriptions, :description
    add_column :organization_descriptions, :description, :jsonb, default: {}
    remove_column :product_descriptions, :description
    add_column :product_descriptions, :description, :jsonb, default: {}
    remove_column :project_descriptions, :description
    add_column :project_descriptions, :description, :jsonb, default: {}
    remove_column :rubric_category_descriptions, :description
    add_column :rubric_category_descriptions, :description, :jsonb, default: {}
    remove_column :tag_descriptions, :description
    add_column :tag_descriptions, :description, :jsonb, default: {}
    remove_column :use_case_descriptions, :description
    add_column :use_case_descriptions, :description, :jsonb, default: {}
    remove_column :use_case_headers, :header
    add_column :use_case_headers, :header, :jsonb, default: {}
    remove_column :use_case_step_descriptions, :description
    add_column :use_case_step_descriptions, :description, :jsonb, default: {}
    remove_column :workflow_descriptions, :description
    add_column :workflow_descriptions, :description, :jsonb, default: {}
  end
end
