# frozen_string_literal: true

module Queries
  class CandidateProductsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::CandidateProductType], null: false

    def resolve(search:)
      return [] if context[:current_user].nil? || !context[:current_user].roles.include?('admin')

      candidate_products = CandidateProduct.order(:name)
      candidate_products = candidate_products.name_contains(search) unless search.blank?
      candidate_products
    end
  end

  class CandidateProductQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::CandidateProductType, null: false

    def resolve(slug:)
      return nil if context[:current_user].nil? || !context[:current_user].roles.include?('admin')

      CandidateProduct.find_by(slug: slug)
    end
  end

  class SearchCandidateProductsQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper

    argument :search, String, required: true
    type Types::CandidateProductType.connection_type, null: false

    def resolve(search:)
      return [] if context[:current_user].nil? || !context[:current_user].roles.include?('admin')

      candidate_products = CandidateProduct.order(rejected: :desc).order(:slug)
      candidate_products = candidate_products.name_contains(search) unless search.blank?
      candidate_products
    end
  end
end
