# frozen_string_literal: true

require 'modules/wizard_helpers'

module Queries
  include Modules::WizardHelpers

  class DatasetsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::DatasetType], null: false

    def resolve(search:)
      datasets = Dataset.order(:name)
      datasets = datasets.name_contains(search) unless search.blank?
      datasets
    end
  end

  class DatasetQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::DatasetType, null: false

    def resolve(slug:)
      Dataset.find_by(slug: slug)
    end
  end

  # rubocop:disable Metrics/ParameterLists
  def filter_datasets(
    search, origins, sectors, sub_sectors, countries, organizations, sdgs, tags, dataset_types,
    sort_hint, _offset_params = {}
  )
    datasets = Dataset.all
    if !search.nil? && !search.to_s.strip.empty?
      name_datasets = datasets.name_contains(search)
      desc_datasets = datasets.joins(:dataset_descriptions)
                              .where('LOWER(description) like LOWER(?)', "%#{search}%")
      datasets = datasets.where(id: (name_datasets + desc_datasets).uniq)
    end

    filtered_origins = origins.reject { |x| x.nil? || x.empty? }
    unless filtered_origins.empty?
      datasets = datasets.joins(:origins)
                         .where(origins: { id: filtered_origins })
    end

    filtered_tags = tags.reject { |x| x.nil? || x.blank? }
    unless filtered_tags.empty?
      datasets = datasets.where(
        "tags @> '{#{filtered_tags.join(',').downcase}}'::varchar[] or " \
        "tags @> '{#{filtered_tags.join(',')}}'::varchar[]"
      )
    end

    filtered_countries = countries.reject { |x| x.nil? || x.empty? }
    unless filtered_countries.empty?
      projects = Project.joins(:countries)
                        .where(countries: { id: filtered_countries })
      datasets = datasets.joins(:projects)
                         .where(projects: { id: projects })
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
      datasets = datasets.joins(:sectors)
                         .where(sectors: { id: filtered_sectors })
    end

    filtered_organizations = organizations.reject { |x| x.nil? || x.empty? }
    unless filtered_organizations.empty?
      datasets = datasets.joins(:organizations)
                         .where(organizations: { id: filtered_organizations })
    end

    filtered_sdgs = sdgs.reject { |x| x.nil? || x.empty? }
    unless filtered_sdgs.empty?
      datasets = datasets.joins(:sustainable_development_goals)
                         .where(sustainable_development_goals: { id: filtered_sdgs })
    end

    unless dataset_types.empty?
      datasets = datasets.where(dataset_type: dataset_types)
    end

    case sort_hint.to_s.downcase
    when 'country'
      datasets = datasets.joins(:countries).order('countries.name')
    when 'sector'
      datasets = datasets.joins(:sectors).order('sectors.name')
    when 'tag'
      datasets = datasets.order('datasets.tags')
    else
      datasets = datasets.order('datasets.name')
    end
    datasets.uniq
  end
  # rubocop:enable Metrics/ParameterLists

  def wizard_datasets(sectors, sub_sectors, tags, sort_hint, offset_params = {})
    sector_ids, curr_sector = get_sector_list(sectors, sub_sectors)
    unless sector_ids.empty?
      sector_datasets = DatasetSector.where(sector_id: sector_ids).map(&:dataset_id)
      if sector_datasets.empty? && !curr_sector.parent_sector_id.nil?
        sector_datasets = DatasetsSector.where(sector_id: curr_sector.parent_sector_id).map(&:dataset_id)
      end
    end

    unless tags.nil?
      tag_datasets = []
      tags.each do |tag|
        tag_datasets += Dataset.where('LOWER(:tag) = ANY(LOWER(datasets.tags::text)::text[])', tag: tag).map(&:id)
      end
    end

    filter_matching_datasets(sector_datasets, tag_datasets, sort_hint, offset_params).uniq
  end

  class SearchDatasetsQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper
    include Queries

    argument :search, String, required: false, default_value: ''
    argument :origins, [String], required: false, default_value: []
    argument :sectors, [String], required: false, default_value: []
    argument :sub_sectors, [String], required: false, default_value: []
    argument :countries, [String], required: false, default_value: []
    argument :organizations, [String], required: false, default_value: []
    argument :sdgs, [String], required: false, default_value: []
    argument :tags, [String], required: false, default_value: []
    argument :dataset_types, [String], required: false, default_value: []

    argument :dataset_sort_hint, String, required: false, default_value: 'name'
    type Types::DatasetType.connection_type, null: false

    def resolve(
      search:, origins:, sectors:, sub_sectors:, countries:, organizations:, sdgs:, tags:, dataset_types:,
      dataset_sort_hint:
    )
      datasets = filter_datasets(
        search, origins, sectors, sub_sectors, countries, organizations, sdgs, tags, dataset_types,
        dataset_sort_hint
      )
      datasets.uniq
    end
  end

  class PaginatedDatasetsQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper
    include Queries

    argument :sectors, [String], required: false, default_value: []
    argument :sub_sectors, [String], required: false, default_value: []
    argument :countries, [String], required: false, default_value: []
    argument :tags, [String], required: false, default_value: []
    argument :offset_attributes, Types::OffsetAttributeInput, required: true

    argument :dataset_sort_hint, String, required: false, default_value: 'name'
    type Types::DatasetType.connection_type, null: false

    def resolve(sectors:, sub_sectors:, countries:, tags:, dataset_sort_hint:, offset_attributes:)
      wizard_datasets(sectors, sub_sectors, countries, tags, dataset_sort_hint, offset_attributes)
    end
  end
end
