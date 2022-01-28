require 'modules/wizard_helpers'

module Queries
  include Modules::WizardHelpers

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

  def filter_projects(
    search, origins, sectors, sub_sectors, countries, organizations, products, sdgs,
    tags, sort_hint, offset_params = {}
  )
    projects = Project.all
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
    user_sectors.each do |user_sector|
      # Find the sector record.
      if user_sector.scan(/\D/).empty?
        sector = Sector.find_by(id: user_sector)
      else
        sector = Sector.find_by(name: user_sector)
      end
      # Skip if we can't find any sector
      next if sector.nil?
      # Add the id to the accepted sector list
      filtered_sectors << sector.id
      # Skip if the parent sector id is empty
      next if sector.parent_sector_id.nil?
      # Iterate over the child sector and match on the subsector if available
      child_sectors = Sector.where(parent_sector_id: sector.id)
      unless sub_sectors.empty?
        child_sectors = child_sectors.select do |child_sector|
          sub_sector_match = false
          sub_sectors.each do |sub_sector|
            # Keepn on skipping if we found a match already
            next if sub_sector_match
            # Try to find a match if we can.
            sub_sector_match = child_sector.name == "#{sector.name}:#{sub_sector}"
          end
          sub_sector_match
        end
      end
      filtered_sectors += child_sectors.map(&:id)
    end
    unless filtered_sectors.empty?
      projects = projects.joins(:sectors)
                         .where(sectors: { id: filtered_sectors })
    end

    filtered_countries = countries.reject { |x| x.nil? || x.empty? }
    unless filtered_countries.empty?
      if filtered_countries.all? { |i| i.scan(/\D/).empty? }
        projects = projects.joins(:countries)
                           .where(countries: { id: filtered_countries })
      else
        projects = projects.joins(:countries)
                           .where(countries: { name: filtered_countries })
      end
    end

    filtered_organizations = organizations.reject { |x| x.nil? || x.empty? }
    unless filtered_organizations.empty?
      projects = projects.joins(:organizations)
                         .where(organizations: { id: filtered_organizations })
    end

    filtered_products = products.reject { |x| x.nil? || x.empty? }
    unless filtered_products.empty?
      projects = projects.joins(:products)
                         .where(products: { id: filtered_products })
    end

    filtered_sdgs = sdgs.reject { |x| x.nil? || x.empty? }
    unless filtered_sdgs.empty?
      projects = projects.joins(:sustainable_development_goals)
                         .where(sustainable_development_goals: { id: filtered_sdgs })
    end

    filtered_tags = tags.reject { |x| x.nil? || x.blank? }
    unless filtered_tags.empty?
      projects = projects.where(
        "tags @> '{#{filtered_tags.join(',').downcase}}'::varchar[] or " \
        "tags @> '{#{filtered_tags.join(',')}}'::varchar[]"
      )
    end

    if sort_hint.to_s.downcase == 'country'
      projects = projects.includes(:countries).order('countries.name')
    elsif sort_hint.to_s.downcase == 'sector'
      projects = projects.includes(:sectors).order('sectors.name')
    elsif sort_hint.to_s.downcase == 'tag'
      projects = projects.order('tags')
    else
      projects = projects.order(:name)
    end
    projects
  end

  def wizard_projects(sectors, sub_sectors, countries, tags, sort_hint, offset_params = {})
    sector_ids, curr_sector = get_sector_list(sectors, sub_sectors)
    get_project_list(sector_ids, curr_sector, countries, tags, sort_hint, offset_params).uniq
  end

  class SearchProjectsQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper
    include Queries

    argument :search, String, required: false, default_value: ''
    argument :origins, [String], required: false, default_value: []
    argument :sectors, [String], required: false, default_value: []
    argument :sub_sectors, [String], required: false, default_value: []
    argument :countries, [String], required: false, default_value: []
    argument :organizations, [String], required: false, default_value: []
    argument :products, [String], required: false, default_value: []
    argument :sdgs, [String], required: false, default_value: []
    argument :tags, [String], required: false, default_value: []

    argument :project_sort_hint, String, required: false, default_value: 'name'
    argument :map_view, Boolean, required: false, default_value: false
    type Types::ProjectType.connection_type, null: false

    def resolve(
      search:, origins:, sectors:, sub_sectors:, countries:, organizations:, products:, sdgs:,
      tags:, project_sort_hint:, map_view:
    )
      projects = filter_projects(
        search, origins, sectors, sub_sectors, countries, organizations, products, sdgs, tags,
        project_sort_hint
      )
      if map_view
        return projects.eager_load(:countries).uniq
      else
        return projects.uniq
      end
    end
  end

  class PaginatedProjectsQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper
    include Queries

    argument :sectors, [String], required: false, default_value: []
    argument :sub_sectors, [String], required: false, default_value: []
    argument :countries, [String], required: false, default_value: []
    argument :tags, [String], required: false, default_value: []
    argument :offset_attributes, Types::OffsetAttributeInput, required: true

    argument :project_sort_hint, String, required: false, default_value: 'name'
    type Types::ProjectType.connection_type, null: false

    def resolve(sectors:, sub_sectors:, countries:, tags:, project_sort_hint:, offset_attributes:)
      wizard_projects(sectors, sub_sectors, countries, tags, project_sort_hint, offset_attributes)
    end
  end
end
