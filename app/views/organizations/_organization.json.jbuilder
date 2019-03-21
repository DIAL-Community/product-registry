json.extract! organization, :id, :id, :name, :when_endorsed, :is_endorser, :website, :created_at, :updated_at, :contacts, :sectors
json.url organization_url(organization, format: :json)
json.offices organization.locations do |location|
  if location.location_type == 'point'
    json.lat location.points[0][0]
    json.lon location.points[0][1]
  end
end
json.countries organization.locations do |location|
  json.merge! location.name if location.location_type == 'country'
end
