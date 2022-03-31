# frozen_string_literal: true

class AddCssHtmlFieldToPlaybooks < ActiveRecord::Migration[5.2]
  def change
    add_column(:playbooks, :design_css, :string)
    add_column(:playbooks, :design_html, :string)
    add_column(:playbooks, :design_components, :string)
    add_column(:playbooks, :design_styles, :string)
    add_column(:playbooks, :design_assets, :string)
  end
end
