json.extract!(task, :id, :name, :slug, :complete, :due_date, :percent_complete,
              :responsible, :created_at, :updated_at)
json.url(task_url(task.play.playbook, task.play, task, format: :json))
