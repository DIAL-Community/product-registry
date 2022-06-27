# frozen_string_literal: true

module Mutations
  class UpdateProjectTags < Mutations::BaseMutation
    argument :tags, [String], required: true
    argument :slug, String, required: true

    field :project, Types::ProjectType, null: true
    field :errors, [String], null: true

    def resolve(tags:, slug:)
      project = Project.find_by(slug: slug)

      unless an_admin || org_owner_check_for_project(project) ||
        product_owner_check_for_project(project)
        return {
          project: nil,
          errors: ['Must have proper rights to update a project']
        }
      end

      project.tags = tags

      if project.save
        # Successful creation, return the created object with no errors
        {
          project: project,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          project: nil,
          errors: project.errors.full_messages
        }
      end
    end
  end
end
