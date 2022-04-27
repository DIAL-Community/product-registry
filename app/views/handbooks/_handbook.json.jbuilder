# frozen_string_literal: true

json.extract!(handbook, :id, :name, :slug, :created_at, :updated_at)
json.url(handbook_url(handbook, format: :json))
