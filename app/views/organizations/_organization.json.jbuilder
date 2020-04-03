json.extract! organization, :id, :name, :slug, :when_endorsed, :is_endorser, :website, :created_at, :updated_at,
              :is_mni
json.url organization_url(organization, format: :json)
json.offices organization.locations do |location|
  if location.location_type == 'point'
    json.lat location.points[0][0]
    json.lon location.points[0][1]
  end
end

json.capabilities organization.aggregator_capabilities do |aggregator_capability|
  json.operator aggregator_capability.operator_services_id
  json.service "#{aggregator_capability.service} #{aggregator_capability.capability}"
  json.country aggregator_capability.country_name
end

json.countries organization.locations do |location|
  json.merge! location.name if location.location_type == 'country'
end

json.sectors organization.sectors do |sector|
  json.merge! sector.id
end
