# frozen_string_literal: true

module Mutations
  class UpdateOrganizationProjects < Mutations::BaseMutation
    argument :projects_slugs, [String], required: true
    argument :slug, String, required: true

    field :organization, Types::OrganizationType, null: true
    field :errors, [String], null: true

    def resolve(projects_slugs:, slug:)
      unless an_admin
        return {
          organization: nil,
          errors: ['Must be admin to update an organization']
        }
      end

      organization = Organization.find_by(slug: slug)

      organization.projects = []
      if !projects_slugs.nil? && !projects_slugs.empty?
        projects_slugs.each do |project_slug|
          current_project = Project.find_by(slug: project_slug)
          unless current_project.nil?
            organization.projects << current_project
          end
        end
      end

      if organization.save
        # Successful creation, return the created object with no errors
        {
          organization: organization,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          organization: nil,
          errors: organization.errors.full_messages
        }
      end
    end
  end
end
