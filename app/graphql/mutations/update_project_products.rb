# frozen_string_literal: true

module Mutations
  class UpdateProjectProducts < Mutations::BaseMutation
    argument :products_slugs, [String], required: true
    argument :slug, String, required: true

    field :project, Types::ProjectType, null: true
    field :errors, [String], null: true

    def resolve(products_slugs:, slug:)
      project = Project.find_by(slug: slug)

      unless an_admin || org_owner_check_for_project(project) ||
        product_owner_check(products_slugs)
        return {
          project: nil,
          errors: ['Must have proper rights to update a project']
        }
      end

      project.products = []
      if !products_slugs.nil? && !products_slugs.empty?
        products_slugs.each do |product_slug|
          current_product = Product.find_by(slug: product_slug)
          unless current_product.nil?
            project.products << current_product
          end
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

    def product_owner_check(products_slugs)
      products_slugs.each do |slug|
        product = Product.find_by(slug: slug)
        if a_product_owner(product.id)
          return true
        end
      end
      false
    end
  end
end
