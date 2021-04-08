module Queries
  class SectorsQuery < Queries::BaseQuery

    type [Types::SectorType], null: false

    def resolve
      Sector.all.order(:slug)
    end
  end
end