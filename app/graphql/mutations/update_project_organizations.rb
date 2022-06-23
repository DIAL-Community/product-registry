# frozen_string_literal: true

module Mutations
  class UpdateProjectOrganizations < Mutations::BaseMutation
    argument :organizations_slugs, [String], required: true
    argument :slug, String, required: true

    field :project, Types::ProjectType, null: true
    field :errors, [String], null: true

    def resolve(organizations_slugs:, slug:)
      project = Project.find_by(slug: slug)

      unless an_admin || org_owner_check(organizations_slugs) || product_owner_check(project)
        return {
          project: nil,
          errors: ['Must have proper rights to update a project']
        }
      end

      project.organizations = []
      if !organizations_slugs.nil? && !organizations_slugs.empty?
        organizations_slugs.each do |organization_slug|
          current_organization = Organization.find_by(slug: organization_slug)
          project.organizations << current_organization unless current_organization.nil?
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

    def org_owner_check(organizations_slugs)
      organizations_slugs.each do |slug|
        organization = Organization.find_by(slug: slug)
        if an_org_owner(organization.id)
          return true
        end
      end
      false
    end

    def product_owner_check(project)
      products = project.products
      products.each do |product|
        if a_product_owner(product.id)
          return true
        end
      end
      false
    end
  end
end
