# frozen_string_literal: true

json.array!(@task_trackers, partial: 'task_trackers/task_tracker', as: :task_tracker)
