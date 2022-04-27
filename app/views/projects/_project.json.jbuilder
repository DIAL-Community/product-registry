# frozen_string_literal: true

json.extract!(project, :id, :name, :slug, :tags)

json.countries(project.countries) do |country|
  json.merge!(country.name)
end

json.sectors(project.sectors) do |sector|
  json.merge!(sector.id)
end

json.project_descriptions(project.project_descriptions) do |proj_desc|
  json.extract!(proj_desc, :description, :locale)
end
