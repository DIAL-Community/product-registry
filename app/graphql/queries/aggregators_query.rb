# frozen_string_literal: true

module Queries
  class AggregatorsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::OrganizationType], null: false

    def resolve(search:)
      organizations = Organization.order(:name)
      organizations = organizations.name_contains(search) unless search.blank?
      organizations.where(is_mni: true)
    end
  end

  class AggregatorQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::OrganizationType, null: false

    def resolve(slug:)
      Organization.find_by(slug: slug)
    end
  end

  def filter_organizations(search, sectors, sub_sectors, countries, services, offset_params = {})
    organizations = Organization.where(is_mni: true).order(:name)

    unless search.blank?
      name_orgs = organizations.name_contains(search)
      desc_orgs = organizations.joins(:organization_descriptions)
                               .where('LOWER(description) like LOWER(?)', "%#{search}%")
      organizations = organizations.where(id: (name_orgs + desc_orgs).uniq)
    end

    filtered_sectors = []
    user_sectors = sectors.reject { |x| x.nil? || x.empty? }
    user_sectors.each do |user_sector|
      # Find the sector record.
      sector = Sector.find_by(name: user_sector)
      sector = Sector.find_by(id: user_sector) if filtered_countries.all? { |i| i.scan(/\D/).empty? }
      # Add the id to the accepted sector list
      filtered_sectors += sector.id
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
      organizations = organizations.joins(:sectors)
                                   .where(sectors: { id: filtered_sectors.uniq })
    end

    filtered_services = services.reject { |x| x.nil? || x.empty? }
    unless filtered_services.empty?
      if filtered_services.all? { |i| i.scan(/\D/).empty? }
        organizations = organizations.joins(:aggregator_capabilities)
                                     .where(aggregator_capabilities: { id: filtered_services })
      else
        organizations = organizations.joins(:aggregator_capabilities)
                                     .where(aggregator_capabilities: { service: filtered_services })
      end
    end

    filtered_countries = countries.reject { |x| x.nil? || x.empty? }
    unless filtered_countries.empty?
      if filtered_countries.all? { |i| i.scan(/\D/).empty? }
        organizations = organizations.joins(:countries)
                                     .where(countries: { id: filtered_countries })
      else
        organizations = organizations.joins(:countries)
                                     .where(countries: { name: filtered_countries })
      end
    end

    organizations = organizations.offset(offset_params[:offset]) unless offset_params.empty?

    organizations.distinct
  end

  class SearchAggregatorsQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper
    include Queries

    argument :search, String, required: false, default_value: ''
    argument :sectors, [String], required: false, default_value: []
    argument :sub_sectors, [String], required: false, default_value: []
    argument :countries, [String], required: false, default_value: []
    argument :services, [String], required: false, default_value: []

    type Types::OrganizationType.connection_type, null: false

    def resolve(search:, sectors:, sub_sectors:, countries:, services:)
      filter_organizations(search, sectors, sub_sectors, countries, aggregators, services)
    end
  end

  class PaginatedAggregatorsQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper
    include Queries

    argument :search, String, required: false, default_value: ''
    argument :sectors, [String], required: false, default_value: []
    argument :sub_sectors, [String], required: false, default_value: []
    argument :countries, [String], required: false, default_value: []
    argument :services, [String], required: false, default_value: []
    argument :offset_attributes, Types::OffsetAttributeInput, required: true

    type Types::OrganizationType.connection_type, null: false

    def resolve(search:, sectors:, sub_sectors:, countries:, services:, offset_attributes:)
      offset_params = offset_attributes.to_h
      filter_organizations(search, sectors, sub_sectors, countries, services, offset_params)
    end
  end
end
