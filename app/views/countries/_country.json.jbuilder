# frozen_string_literal: true

json.extract! country, :id, :name, :code, :latitude, :longitude
json.url country_url(country, format: :json)
