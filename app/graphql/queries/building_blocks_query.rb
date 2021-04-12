module Queries
  class BuildingBlocksQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::BuildingBlockType], null: false

    def resolve(search:)
      building_blocks = BuildingBlock.order(:name)
      unless search.blank?
        building_blocks = building_blocks.name_contains(search)
      end
      building_blocks
    end
  end

  class SearchBuildingBlocksQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper

    argument :search, String, required: false, default_value: ''
    argument :sdgs, [String], required: false, default_value: []
    argument :use_cases, [String], required: false, default_value: []
    argument :workflows, [String], required: false, default_value: []

    type Types::BuildingBlockType.connection_type, null: false

    def resolve(search:, sdgs:, use_cases:, workflows:)
      building_blocks = BuildingBlock.order(:name)
      unless search.blank?
        building_blocks = building_blocks.name_contains(search)
      end

      filtered_workflows = workflows.reject { |x| x.nil? || x.empty? }
      unless filtered_workflows.empty?
        building_blocks = building_blocks.joins(:workflows)
                                         .where(workflows: { id: filtered_workflows })
      end
      building_blocks
    end
  end
end
