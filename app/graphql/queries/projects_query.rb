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

  class ProjectQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::ProjectType, null: false

    def resolve(slug:)
      Project.find_by(slug: slug)
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
      projects = Project.order(:name).eager_load(:countries)
      if !search.nil? && !search.to_s.strip.empty?
        name_projects = projects.name_contains(search)
        desc_projects = projects.joins(:project_descriptions)
                                .where("LOWER(description) like LOWER(?)", "%#{search}%")
        projects = projects.where(id: (name_projects + desc_projects).uniq)
      end

      filtered_origins = origins.reject { |x| x.nil? || x.empty? }
      unless filtered_origins.empty?
        projects = projects.where(origin_id: filtered_origins)
      end

      filtered_sectors = []
      user_sectors = sectors.reject { |x| x.nil? || x.empty? }
      unless user_sectors.empty?
        filtered_sectors = user_sectors.clone
      end
      user_sectors.each do |user_sector|
        curr_sector = Sector.find(user_sector)
        if curr_sector.parent_sector_id.nil?
          child_sectors = Sector.where(parent_sector_id: curr_sector.id)
          filtered_sectors = filtered_sectors + child_sectors.map(&:id)
        end
      end
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

      filtered_sdgs = sdgs.reject { |x| x.nil? || x.empty? }
      unless filtered_sdgs.empty?
        projects = projects.joins(:sustainable_development_goals)
                           .where(sustainable_development_goals: { id: filtered_sdgs })
      end
      projects.distinct
    end
  end
end
