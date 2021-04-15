module Types
  class UseCaseStepType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false

    field :use_case, Types::UseCaseType, null: false
    field :workflows, [Types::WorkflowType], null: false
  end
end
