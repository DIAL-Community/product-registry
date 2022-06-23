# frozen_string_literal: true

module Mutations
  class UpdateProjectSectors < Mutations::BaseMutation
    argument :sectors_slugs, [String], required: true
    argument :slug, String, required: true

    field :project, Types::ProjectType, null: true
    field :errors, [String], null: true

    def resolve(sectors_slugs:, slug:)
      project = Project.find_by(slug: slug)

      unless an_admin || org_owner_check_for_project(project) ||
        product_owner_check_for_project(project)
        return {
          project: nil,
          errors: ['Must have proper rights to update a project']
        }
      end

      project.sectors = []
      if !sectors_slugs.nil? && !sectors_slugs.empty?
        sectors_slugs.each do |sector_slug|
          current_sector = Sector.where("slug in (?)", sector_slug)
          project.sectors << current_sector unless current_sector.nil?
        end
      end

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
