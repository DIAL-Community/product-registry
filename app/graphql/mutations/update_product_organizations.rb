# frozen_string_literal: true

module Mutations
  class UpdateProductOrganizations < Mutations::BaseMutation
    argument :organizations_slugs, [String], required: true
    argument :slug, String, required: true

    field :product, Types::ProductType, null: true
    field :errors, [String], null: true

    def resolve(organizations_slugs:, slug:)
      product = Product.find_by(slug: slug)

      unless an_admin || a_product_owner(product.id)
        return {
          product: nil,
          errors: ['Must be admin or product owner to update a product']
        }
      end

      product.organizations = []
      if !organizations_slugs.nil? && !organizations_slugs.empty?
        organizations_slugs.each do |organization_slug|
          current_organization = Organization.find_by(slug: organization_slug)
          product.organizations << current_organization unless current_organization.nil?
        end
      end

      if product.save
        # Successful creation, return the created object with no errors
        {
          product: product,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          product: nil,
          errors: product.errors.full_messages
        }
      end
    end
  end
end
