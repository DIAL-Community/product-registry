# frozen_string_literal: true

class ChangeDataTypeForLastRun < ActiveRecord::Migration[5.2]
  def self.up
    change_table(:task_trackers) do |t|
      t.change(:last_run, :datetime)
    end
  end

  def self.down
    change_table(:task_trackers) do |t|
      t.change(:last_run, :date)
    end
  end
end
