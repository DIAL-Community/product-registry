# frozen_string_literal: true

module Mutations
  class DeleteRubricCategory < Mutations::BaseMutation
    argument :id, ID, required: true

    field :rubric_category, Types::RubricCategoryType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      unless an_admin
        return {
          rubric_category: nil,
          errors: ['Must be admin to delete a rubric category']
        }
      end

      rubric_category = RubricCategory.find_by(id: id)

      if rubric_category.destroy
        # Successful deletetion, return the nil rubric category with no errors
        {
          rubric_category: nil,
          errors: []
        }
      else
        # Failed delete, return the errors to the client
        {
          rubric_category: rubric_category,
          errors: rubric_category.errors.full_messages
        }
      end
    end
  end
end
