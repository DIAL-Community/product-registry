# frozen_string_literal: true

json.extract!(task_tracker, :id, :name, :slug, :last_run, :created_at, :updated_at)
json.url(task_tracker_url(task_tracker, format: :json))
