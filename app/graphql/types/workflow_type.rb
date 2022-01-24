module Types
  class WorkflowDescriptionType < Types::BaseObject
    field :id, ID, null: false
    field :use_case_id, Integer, null: true
    field :locale, String, null: false
    field :description, String, null: false
  end

  class WorkflowType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :image_file, String, null: false

    field :workflow_descriptions, [Types::WorkflowDescriptionType], null: true
    field :workflow_description, Types::WorkflowDescriptionType, null: true,
      method: :workflow_description_localized

    field :use_case_steps, [Types::UseCaseStepType], null: true
    field :building_blocks, [Types::BuildingBlockType], null: true
  end
end
