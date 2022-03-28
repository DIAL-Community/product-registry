# frozen_string_literal: true

module Queries
  class OriginsQuery < Queries::BaseQuery
    argument :search, String, required: true
    type [Types::OriginType], null: false

    def resolve(search:)
      origins = Origin.order(:name)
      origins = origins.name_contains(search) unless search.blank?
      origins
    end
  end

  class SearchOriginsQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper

    argument :search, String, required: true
    type Types::OriginType.connection_type, null: false

    def resolve(search:)
      origins = Origin.order(:name)
      origins = origins.name_contains(search) unless search.blank?
      origins
    end
  end
end
