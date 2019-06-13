json.extract! sdg_target, :id, :name, :slug, :target_number, :created_at, :updated_at, :sdg_number
json.url sdg_target_url(sdg_target, format: :json)
