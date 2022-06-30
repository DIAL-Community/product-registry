# frozen_string_literal: true

module Mutations
  class UpdateUseCaseSdgTargets < Mutations::BaseMutation
    argument :sdg_targets_ids, [Integer], required: true
    argument :slug, String, required: true

    field :use_case, Types::UseCaseType, null: true
    field :errors, [String], null: true

    def resolve(sdg_targets_ids:, slug:)
      use_case = UseCase.find_by(slug: slug)

      unless an_admin || a_content_editor
        return {
          use_case: nil,
          errors: ['Must be an admin or content editor to update use case']
        }
      end

      use_case.sdg_targets = []
      if !sdg_targets_ids.nil? && !sdg_targets_ids.empty?
        sdg_targets_ids.each do |id|
          current_sdg_target = SdgTarget.find_by(id: id)
          use_case.sdg_targets << current_sdg_target unless current_sdg_target.nil?
        end
      end

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
