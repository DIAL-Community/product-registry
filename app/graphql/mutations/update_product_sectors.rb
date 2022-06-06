# frozen_string_literal: true

module Mutations
  class UpdateProductSectors < Mutations::BaseMutation
    argument :sectors_slugs, [String], required: true
    argument :slug, String, required: true

    field :product, Types::ProductType, null: true
    field :errors, [String], null: true

    def resolve(sectors_slugs:, slug:)
      product = Product.find_by(slug: slug)

      unless an_admin || a_product_owner(product.id)
        return {
          product: nil,
          errors: ['Must be admin or product owner to update a product']
        }
      end

      product.sectors = []
      if !sectors_slugs.nil? && !sectors_slugs.empty?
        sectors_slugs.each do |sector_slug|
          current_sector = Sector.where("slug in (?)", sector_slug)
          product.sectors << current_sector unless current_sector.nil?
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
