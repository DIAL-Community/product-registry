# frozen_string_literal: true

module Mutations
  class UpdateBuildingBlockProducts < Mutations::BaseMutation
    argument :products_slugs, [String], required: true
    argument :mapping_status, String, required: true
    argument :slug, String, required: true

    field :building_block, Types::BuildingBlockType, null: true
    field :errors, [String], null: true

    def resolve(products_slugs:, slug:, mapping_status:)
      unless an_admin || a_content_editor
        return {
          building_block: nil,
          errors: ['Must be admin or content editor to update building block']
        }
      end

      building_block = BuildingBlock.find_by(slug: slug)

      building_block.products = []
      products_slugs&.each do |product_slug|
        current_product = Product.find_by(slug: product_slug)
        building_block.products << current_product unless current_product.nil?
        # For every product assign the mapping status
        current_building_block_product = ProductBuildingBlock.find_by(slug: "#{product_slug}_#{slug}")
        unless current_building_block_product.nil?
          current_building_block_product.mapping_status = mapping_status
          current_building_block_product.save
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
