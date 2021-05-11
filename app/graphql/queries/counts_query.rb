module Queries
  class CountsQuery < Queries::BaseQuery
    type Types::CountType, null: false

    def resolve()
      counts = {}
      counts['sdgCount'] = SustainableDevelopmentGoal.count
      counts['useCaseCount'] = UseCase.where(maturity: 'MATURE').count
      counts['workflowCount'] = Workflow.count
      counts['buildingBlockCount'] = BuildingBlock.count
      counts['productCount'] = Product.where(parent_product_id: nil).count
      counts['projectCount'] = Project.count
      counts['orgCount'] = Organization.count
      counts['mapCount'] = 3
      
      counts
    end
  end
end