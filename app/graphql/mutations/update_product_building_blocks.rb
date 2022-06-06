# frozen_string_literal: true

module Mutations
  class UpdateProductBuildingBlocks < Mutations::BaseMutation
    argument :building_blocks_slugs, [String], required: true
    argument :slug, String, required: true

    field :product, Types::ProductType, null: true
    field :errors, [String], null: true

    def resolve(building_blocks_slugs:, slug:)
      product = Product.find_by(slug: slug)

      unless an_admin || a_product_owner(product.id)
        return {
          product: nil,
          errors: ['Must be admin or product owner to update a product']
        }
      end

      product.building_blocks = []
      if !building_blocks_slugs.nil? && !building_blocks_slugs.empty?
        building_blocks_slugs.each do |building_block_slug|
          current_building_block = BuildingBlock.find_by(slug: building_block_slug)
          product.building_blocks << current_building_block unless current_building_block.nil?
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
