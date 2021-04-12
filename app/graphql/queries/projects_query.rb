module Queries
  class ProjectsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::ProjectType], null: false

    def resolve(search:)
      projects = Project.order(:name)
      unless search.blank?
        projects = projects.name_contains(search)
      end
      projects
    end
  end

  class SearchProjectsQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper

    argument :search, String, required: false, default_value: ''
    argument :origins, [String], required: false, default_value: []
    argument :sectors, [String], required: false, default_value: []
    argument :countries, [String], required: false, default_value: []
    argument :organizations, [String], required: false, default_value: []
    argument :sdgs, [String], required: false, default_value: []

    type Types::ProjectType.connection_type, null: false

    def resolve(search:, origins:, sectors:, countries:, organizations:, sdgs:)
      projects = Project.order(:name)
      if !search.nil? && !search.to_s.strip.empty?
        projects = projects.name_contains(search)
      end

      filtered_origins = origins.reject { |x| x.nil? || x.empty? }
      unless filtered_origins.empty?
        projects = projects.joins(:origins)
                           .where(origins: { id: filtered_origins })
      end

      filtered_sectors = sectors.reject { |x| x.nil? || x.empty? }
      unless filtered_sectors.empty?
        projects = projects.joins(:sectors)
                           .where(sectors: { id: filtered_sectors })
      end

      filtered_countries = countries.reject { |x| x.nil? || x.empty? }
      unless filtered_countries.empty?
        projects = projects.joins(:countries)
                           .where(countries: { id: filtered_countries })
      end

      filtered_organizations = organizations.reject { |x| x.nil? || x.empty? }
      unless filtered_organizations.empty?
        projects = projects.joins(:organizations)
                           .where(organizations: { id: filtered_organizations })
      end
      projects
    end
  end
end
