module Types
  class CountType < Types::BaseObject
    field :sdgCount, Integer, null: false
    field :useCaseCount, Integer, null: false
    field :workflowCount, Integer, null: false
    field :buildingBlockCount, Integer, null: false
    field :productCount, Integer, null: false
    field :projectCount, Integer, null: false
    field :orgCount, Integer, null: false
    field :mapCount, Integer, null: false
  end
end