module Queries
  class OrganizationsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::OrganizationType], null: false

    def resolve(search:)
      organizations = Organization.order(:name)
      unless search.blank?
        organizations = organizations.name_contains(search)
      end
      organizations
    end
  end

  class OrganizationQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::OrganizationType, null: false

    def resolve(slug:)
      Organization.find_by(slug: slug)
    end
  end

  class SearchOrganizationsQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper

    argument :search, String, required: false, default_value: ''
    argument :sectors, [String], required: false, default_value: []
    argument :countries, [String], required: false, default_value: []
    argument :years, [Int], required: false, default_value: []
    argument :aggregator_only, Boolean, required: false, default_value: false
    type Types::OrganizationType.connection_type, null: false

    def resolve(search:, sectors:, countries:, years:, aggregator_only:)
      organizations = Organization.order(:name)
                                  .eager_load(:countries, :offices)
      unless search.blank?
        organizations = organizations.name_contains(search)
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
        organizations = organizations.joins(:sectors)
                                     .where(sectors: { id: filtered_sectors })
      end

      filtered_countries = countries.reject { |x| x.nil? || x.empty? }
      unless filtered_countries.empty?
        organizations = organizations.joins(:countries)
                                     .where(countries: { id: filtered_countries })
      end

      unless years.empty?
        organizations = organizations.where('extract(year from when_endorsed) in (?)', years)
      end

      if aggregator_only
        organizations = organizations.where(is_mni: true)
      end

      organizations.distinct
    end
  end
end
