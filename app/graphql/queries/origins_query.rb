module Queries
  class OriginsQuery < Queries::BaseQuery
    argument :search, String, required: true
    type [Types::OriginType], null: false

    def resolve(search:)
      origins = Origin.order(:name)
      unless search.blank?
        origins = origins.name_contains(search)
      end
      origins
    end
  end

  class SearchOriginsQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper

    argument :search, String, required: true
    type Types::OriginType.connection_type, null: false

    def resolve(search:)
      origins = Origin.order(:name)
      unless search.blank?
        origins = origins.name_contains(search)
      end
      origins
    end
  end
end
