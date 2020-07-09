class AddTaskTrackerDescription < ActiveRecord::Migration[5.2]
  def change
    create_table :task_tracker_descriptions do |t|
      t.references(:task_tracker, foreign_key: true, null: false)
      t.string(:locale, null: false)
      t.jsonb(:description, null: false, default: {})
    end
  end
end
