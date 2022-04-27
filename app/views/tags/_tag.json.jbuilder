# frozen_string_literal: true

json.extract!(tag, :id, :name, :slug, :created_at, :updated_at, :tag_descriptions)
json.url(tag_url(tag, format: :json))
