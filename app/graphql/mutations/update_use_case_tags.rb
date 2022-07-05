# frozen_string_literal: true

module Mutations
  class UpdateUseCaseTags < Mutations::BaseMutation
    argument :tags, [String], required: true
    argument :slug, String, required: true

    field :use_case, Types::UseCaseType, null: true
    field :errors, [String], null: true

    def resolve(tags:, slug:)
      unless an_admin || a_content_editor
        return {
          use_case: nil,
          errors: ['Must be an admin or content editor to update use case']
        }
      end

      use_case = UseCase.find_by(slug: slug)

      use_case.tags = tags

      if use_case.save
        # Successful creation, return the created object with no errors
        {
          use_case: use_case,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          use_case: nil,
          errors: use_case.errors.full_messages
        }
      end
    end
  end
end
