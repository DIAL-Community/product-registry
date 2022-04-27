# frozen_string_literal: true

class AddOrgTypeToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column(:projects_organizations, :org_type, :org_type, default: 'owner')

    add_column(:projects, :project_url, :string)
  end
end
