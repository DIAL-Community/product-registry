# frozen_string_literal: true

class MakeFieldsNotNullable < ActiveRecord::Migration[5.2]
  def up
    change_column(:product_suites, :description, :jsonb, null: false, default: {})
  end

  def down
    change_column(:product_suites, :description, :string)
  end

  def change
    change_column_null(:building_block_descriptions, :building_block_id, false)
    change_column_default(:building_block_descriptions, :description, from: '{}', to: {})

    change_column_null(:building_blocks, :name, false)
    change_column_null(:building_blocks, :slug, false)
    change_column_default(:building_blocks, :description, from: '{}', to: {})

    change_column_default(:glossaries, :description, from: '{}', to: {})

    change_column_null(:category_indicator_descriptions, :category_indicator_id, false)
    change_column_null(:maturity_rubric_descriptions, :maturity_rubric_id, false)

    change_column_null(:organization_descriptions, :organization_id, false)
    change_column_default(:organization_descriptions, :description, from: '{}', to: {})

    change_column_null(:organizations, :name, false)
    change_column_default(:organizations, :is_endorser, from: nil, to: false)

    change_column_null(:portal_views, :name, false)
    change_column_null(:portal_views, :description, false)

    change_column_null(:product_descriptions, :product_id, false)
    change_column_default(:product_descriptions, :description, from: '{}', to: {})

    change_column_null(:product_suites, :name, false)

    change_column_null(:product_versions, :product_id, false)

    change_column_null(:products, :name, false)
    change_column_default(:products, :start_assessment, from: nil, to: false)
    change_column_default(:products, :statistics, from: '{}', to: {})

    change_column_null(:project_descriptions, :project_id, false)
    change_column_default(:project_descriptions, :description, from: '{}', to: {})

    change_column_null(:rubric_categories, :maturity_rubric_id, false)

    change_column_null(:rubric_category_descriptions, :rubric_category_id, false)

    change_column_null(:sdg_targets, :name, false)
    change_column_null(:sdg_targets, :target_number, false)
    # change_column_null(:sdg_targets, :slug, false)
    change_column_null(:sdg_targets, :sdg_number, false)

    change_column_null(:sectors, :slug, false)
    change_column_null(:sectors, :name, false)

    change_column_null(:contacts, :name, false)

    change_column_default(:stylesheets, :about_page, from: '{}', to: {})
    change_column_default(:stylesheets, :footer_content, from: '{}', to: {})

    change_column_null(:sustainable_development_goals, :slug, false)
    change_column_null(:sustainable_development_goals, :name, false)
    change_column_null(:sustainable_development_goals, :long_title, false)
    change_column_null(:sustainable_development_goals, :number, false)

    change_column_null(:tag_descriptions, :tag_id, false)
    change_column_default(:tag_descriptions, :description, from: '{}', to: {})

    change_column_null(:tags, :name, false)
    change_column_null(:tags, :slug, false)

    change_column_null(:use_case_descriptions, :use_case_id, false)
    change_column_default(:use_case_descriptions, :description, from: '{}', to: {})

    change_column_null(:use_case_headers, :use_case_id, false)

    change_column_null(:use_case_step_descriptions, :use_case_step_id, false)
    change_column_default(:use_case_step_descriptions, :description, from: '{}', to: {})

    change_column_null(:use_case_steps, :name, false)
    change_column_null(:use_case_steps, :slug, false)
    change_column_null(:use_case_steps, :use_case_id, false)

    change_column_null(:use_cases, :name, false)
    change_column_null(:use_cases, :slug, false)
    change_column_null(:use_cases, :sector_id, false)
    change_column_default(:use_cases, :description, from: '{}', to: {})

    change_column_null(:workflow_descriptions, :workflow_id, false)
    change_column_default(:workflow_descriptions, :description, from: '{}', to: {})

    change_column_null(:workflows, :name, false)
    change_column_null(:workflows, :slug, false)
    change_column_default(:workflows, :description, from: '{}', to: {})
  end
end
