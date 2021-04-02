module Queries
  class BuildingBlocksQuery < Queries::BaseQuery

    type [Types::BuildingBlockType], null: false

    def resolve
      BuildingBlock.all.order(:slug)
    end
  end
end