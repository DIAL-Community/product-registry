# frozen_string_literal: true

module Mutations
  class DeleteCategoryIndicator < Mutations::BaseMutation
    argument :id, ID, required: true

    field :category_indicator, Types::CategoryIndicatorType, null: true
    field :rubric_category_slug, String, null: true
    field :errors, [String], null: true

    def resolve(id:)
      category_indicator = CategoryIndicator.find_by(id: id)

      unless an_admin
        return {
          category_indicator: nil,
          rubric_category_slug: nil,
          errors: ['Must be admin to delete a category indicator']
        }
      end

      rubric_category = RubricCategory.find_by(id: category_indicator.rubric_category_id)

      if category_indicator.destroy
        # Successful deletetion, return the nil category indicator with no errors
        {
          category_indicator: nil,
          rubric_category_slug: rubric_category.slug,
          errors: []
        }
      else
        # Failed delete, return the errors to the client
        {
          category_indicator: category_indicator,
          rubric_category_slug: rubric_category.slug,
          errors: category_indicator.errors.full_messages
        }
      end
    end
  end
end
