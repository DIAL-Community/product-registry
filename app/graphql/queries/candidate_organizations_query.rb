module Queries
  class CandidateOrganizationsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::CandidateOrganizationType], null: false

    def resolve(search:)
      candidate_organizations = CandidateOrganization.order(:name)
      unless search.blank?
        candidate_organizations = candidate_organizations.name_contains(search)
      end
      candidate_organizations
    end
  end

  class CandidateOrganizationQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::CandidateOrganizationType, null: false

    def resolve(slug:)
      CandidateOrganization.find_by(slug: slug)
    end
  end

  class SearchCandidateOrganizationsQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper

    argument :search, String, required: true
    type Types::CandidateOrganizationType.connection_type, null: false

    def resolve(search:)
      candidate_organizations = CandidateOrganization.order(rejected: :desc).order(:slug)
      unless search.blank?
        candidate_organizations = candidate_organizations.name_contains(search)
      end
      candidate_organizations
    end
  end
end
