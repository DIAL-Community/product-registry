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
    type Types::OrganizationType.connection_type, null: false

    def resolve(search:, sectors:, countries:)
      organizations = Organization.order(:name)
      unless search.blank?
        organizations = organizations.name_contains(search)
      end

      filtered_sectors = sectors.reject { |x| x.nil? || x.empty? }
      unless filtered_sectors.empty?
        organizations = organizations.joins(:sectors)
                                     .where(sectors: { id: filtered_sectors })
      end

      filtered_countries = countries.reject { |x| x.nil? || x.empty? }
      unless filtered_countries.empty?
        organizations = organizations.joins(:countries)
                                     .where(countries: { id: filtered_countries })
      end
      organizations.distinct
    end
  end
end
