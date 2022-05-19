# frozen_string_literal: true

module Mutations
  class UpdateOrganizationProducts < Mutations::BaseMutation
    argument :products_slugs, [String], required: true
    argument :slug, String, required: true

    field :organization, Types::OrganizationType, null: true
    field :errors, [String], null: true

    def resolve(products_slugs:, slug:)
      unless an_admin
        return {
          organization: nil,
          errors: ['Must be admin to update an organization']
        }
      end

      organization = Organization.find_by(slug: slug)

      organization.products = []
      if !products_slugs.nil? && !products_slugs.empty?
        products_slugs.each do |product_slug|
          current_product = Product.find_by(slug: product_slug)
          unless current_product.nil?
            organization.products << current_product
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
