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
      organizations.distinct
    end
  end
end
