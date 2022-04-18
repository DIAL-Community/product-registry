# frozen_string_literal: true

json.extract!(candidate_organization, :id, :name, :slug, :website, :created_at, :updated_at)
json.url(candidate_organization_url(candidate_organization, format: :json))
