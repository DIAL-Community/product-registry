# frozen_string_literal: true

module Queries
  class CandidateOrganizationsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::CandidateOrganizationType], null: false

    def resolve(search:)
      return [] if context[:current_user].nil? || !context[:current_user].roles.include?('admin')

      candidate_organizations = CandidateOrganization.order(:name)
      candidate_organizations = candidate_organizations.name_contains(search) unless search.blank?
      candidate_organizations
    end
  end

  class CandidateOrganizationQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::CandidateOrganizationType, null: false

    def resolve(slug:)
      return nil if context[:current_user].nil? || !context[:current_user].roles.include?('admin')

      CandidateOrganization.find_by(slug: slug)
    end
  end

  class SearchCandidateOrganizationsQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper

    argument :search, String, required: true
    type Types::CandidateOrganizationType.connection_type, null: false

    def resolve(search:)
      return [] if context[:current_user].nil? || !context[:current_user].roles.include?('admin')

      candidate_organizations = CandidateOrganization.order(rejected: :desc).order(:slug)
      candidate_organizations = candidate_organizations.name_contains(search) unless search.blank?
      candidate_organizations
    end
  end
end
