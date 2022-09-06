# frozen_string_literal: true

json.extract!(rubric_category, :id, :name, :slug, :weight, :created_at, :updated_at)
json.url(rubric_category_url(rubric_category, format: :json))
