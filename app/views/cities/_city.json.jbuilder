# frozen_string_literal: true

json.extract!(city, :id)

city_name = city.name
unless city.region.nil?
  city_name = "#{city_name}, #{city.region.name}"
  city_name = "#{city_name}, #{city.region.country.code}" unless city.region.country.nil?
end

json.name(city_name)
json.url(city_url(city, format: :json))
