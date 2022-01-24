module Types
  class UseCaseStepDescriptionType < Types::BaseObject
    field :id, ID, null: false
    field :use_case_id, Integer, null: true
    field :locale, String, null: false
    field :description, String, null: false
  end

  class UseCaseStepType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :step_number, Integer, null: false

    field :use_case_step_descriptions, [Types::UseCaseStepDescriptionType], null: true
    field :use_case_step_description, Types::UseCaseStepDescriptionType, null: true,
      method: :use_case_step_description_localized

    field :use_case, Types::UseCaseType, null: false
    field :workflows, [Types::WorkflowType], null: false
    field :products, [Types::ProductType], null: true
    field :building_blocks, [Types::BuildingBlockType], null: true
  end
end
