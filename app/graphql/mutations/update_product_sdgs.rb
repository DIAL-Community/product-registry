# frozen_string_literal: true

module Mutations
  class UpdateProductSdgs < Mutations::BaseMutation
    argument :sdgs_slugs, [String], required: true
    argument :mapping_status, String, required: true
    argument :slug, String, required: true

    field :product, Types::ProductType, null: true
    field :errors, [String], null: true

    def resolve(sdgs_slugs:, mapping_status:, slug:)
      product = Product.find_by(slug: slug)

      unless an_admin || a_product_owner(product.id)
        return {
          product: nil,
          errors: ['Must be admin or product owner to update a product']
        }
      end

      product.sustainable_development_goals = []
      if !sdgs_slugs.nil? && !sdgs_slugs.empty?
        sdgs_slugs.each do |sdg_slug|
          current_sdg = SustainableDevelopmentGoal.find_by(slug: sdg_slug)
          product.sustainable_development_goals << current_sdg unless current_sdg.nil?
        end
      end

      # For every sdg assign the mapping status
      product_sdgs = ProductSustainableDevelopmentGoal.where(product_id: product.id)
      if !product_sdgs.nil? && !product_sdgs.empty?
        product_sdgs.each do |product_sdg|
          product_sdg.mapping_status = mapping_status
          product_sdg.save
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
