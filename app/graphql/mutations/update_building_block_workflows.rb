# frozen_string_literal: true

module Mutations
  class UpdateBuildingBlockWorkflows < Mutations::BaseMutation
    argument :workflows_slugs, [String], required: true
    argument :slug, String, required: true

    field :building_block, Types::BuildingBlockType, null: true
    field :errors, [String], null: true

    def resolve(workflows_slugs:, slug:)
      unless an_admin || a_content_editor
        return {
          building_block: nil,
          errors: ['Must be admin or content editor to update building block']
        }
      end

      building_block = BuildingBlock.find_by(slug: slug)

      building_block.workflows = []
      if !workflows_slugs.nil? && !workflows_slugs.empty?
        workflows_slugs.each do |workflow_slug|
          current_workflow = Workflow.find_by(slug: workflow_slug)
          building_block.workflows << current_workflow unless current_workflow.nil?
        end
      end

      if building_block.save
        # Successful creation, return the created object with no errors
        {
          building_block: building_block,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          building_block: nil,
          errors: building_block.errors.full_messages
        }
      end
    end
  end
end
