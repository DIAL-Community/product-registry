json.extract! organization, :id, :name, :slug, :when_endorsed, :is_endorser, :website, :created_at, :updated_at,
              :is_mni
json.url organization_url(organization, format: :json)
json.offices organization.offices do |office|
    json.lat office.latitude
    json.lon office.longitude
end

if organization.is_mni
  json.capabilities organization.aggregator_capabilities do |aggregator_capability|
    json.operator aggregator_capability.operator_services_id
    json.service "#{aggregator_capability.service} #{aggregator_capability.capability}"
    json.country aggregator_capability.country_name
  end
end

json.countries organization.countries do |country|
  json.merge! country.name
end

json.sectors organization.sectors do |sector|
  json.merge! sector.id
end
