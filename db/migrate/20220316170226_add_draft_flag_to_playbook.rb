class AddDraftFlagToPlaybook < ActiveRecord::Migration[5.2]
  def change
    add_column(:playbooks, :draft, :boolean, null: false, default: true)
  end
end
