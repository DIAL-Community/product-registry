# frozen_string_literal: true

module Mutations
  class DeleteOrganization < Mutations::BaseMutation
    argument :id, ID, required: true

    field :organization, Types::OrganizationType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      unless an_admin
        return {
          organization: nil,
          errors: ['Must be admin to delete an organization']
        }
      end
      organization = Organization.find_by(id: id)

      if organization.destroy
        # Successful deletetion, return the nil organization with no errors
        {
          organization: nil,
          errors: []
        }
      else
        # Failed delete, return the errors to the client
        {
          organization: organization,
          errors: organization.errors.full_messages
        }
      end
    end
  end
end
