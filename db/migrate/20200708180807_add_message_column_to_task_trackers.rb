class AddMessageColumnToTaskTrackers < ActiveRecord::Migration[5.2]
  def change
    add_column(:task_trackers, :message, :string, null: false)
  end
end
