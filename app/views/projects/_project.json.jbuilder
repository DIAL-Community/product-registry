json.extract! project, :id, :name, :slug

json.countries project.countries do |country|
  json.merge! country.name
end