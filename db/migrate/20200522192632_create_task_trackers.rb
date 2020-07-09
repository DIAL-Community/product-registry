class CreateTaskTrackers < ActiveRecord::Migration[5.2]
  def change
    create_table :task_trackers do |t|
      t.string(:name, null: false)
      t.string(:slug, unique: true, null: false)
      t.date(:last_run)

      t.timestamps
    end
  end
end
