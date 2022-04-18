# frozen_string_literal: true

json.extract!(sector, :id, :name, :slug, :created_at, :updated_at)
json.url(sector_url(sector, format: :json))
