# frozen_string_literal: true

module Mutations
  class UpdateWorkflowBuildingBlocks < Mutations::BaseMutation
    argument :building_blocks_slugs, [String], required: true
    argument :slug, String, required: true

    field :workflow, Types::WorkflowType, null: true
    field :errors, [String], null: true

    def resolve(building_blocks_slugs:, slug:)
      unless an_admin || a_content_editor
        return {
          workflow: nil,
          errors: ['Must be admin or content editor to update workflow']
        }
      end

      workflow = Workflow.find_by(slug: slug)

      workflow.building_blocks = []
      building_blocks_slugs&.each do |building_block_slug|
        current_building_block = BuildingBlock.find_by(slug: building_block_slug)
        workflow.building_blocks << current_building_block unless current_building_block.nil?
      end

      if workflow.save
        # Successful creation, return the created object with no errors
        {
          workflow: workflow,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          workflow: nil,
          errors: workflow.errors.full_messages
        }
      end
    end
  end
end
