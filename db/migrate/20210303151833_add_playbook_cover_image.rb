class AddPlaybookCoverImage < ActiveRecord::Migration[5.2]
  def change
    remove_column(:playbooks, :design_css, :string)
    remove_column(:playbooks, :design_html, :string)
    remove_column(:playbooks, :design_components, :string)
    remove_column(:playbooks, :design_styles, :string)
    remove_column(:playbooks, :design_assets, :string)

    add_column(:playbook_descriptions, :cover, :string, :null => true)
    add_column(:playbooks, :pdf_url, :string, :null => true)
  end
end
