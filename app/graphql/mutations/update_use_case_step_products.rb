# frozen_string_literal: true

module Mutations
  class UpdateUseCaseStepProducts < Mutations::BaseMutation
    argument :products_slugs, [String], required: true
    argument :slug, String, required: true

    field :use_case_step, Types::UseCaseStepType, null: true
    field :errors, [String], null: true

    def resolve(products_slugs:, slug:)
      unless an_admin || a_content_editor
        return {
          use_case_step: nil,
          errors: ['Must be admin or content editor to update use case step']
        }
      end

      use_case_step = UseCaseStep.find_by(slug: slug)

      use_case_step.products = []
      if !products_slugs.nil? && !products_slugs.empty?
        products_slugs.each do |product_slug|
          current_product = Product.find_by(slug: product_slug)
          use_case_step.products << current_product unless current_product.nil?
        end
      end

      if use_case_step.save
        # Successful creation, return the created object with no errors
        {
          use_case_step: use_case_step,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          use_case_step: nil,
          errors: use_case_step.errors.full_messages
        }
      end
    end
  end
end
