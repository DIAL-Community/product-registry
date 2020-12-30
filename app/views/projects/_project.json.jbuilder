json.extract! project, :id, :name, :slug, :tags

json.countries project.countries do |country|
  json.merge! country.name
end

json.sectors project.sectors do |sector|
  json.merge! sector.id
end
