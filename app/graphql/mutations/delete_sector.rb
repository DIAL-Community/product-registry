# frozen_string_literal: true

module Mutations
  class DeleteSector < Mutations::BaseMutation
    argument :id, ID, required: true

    field :sector, Types::SectorType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      unless an_admin
        return {
          sector: nil,
          errors: ['Must be admin to delete an sector.']
        }
      end

      sector = Sector.find_by(id: id)
      if sector.destroy
        # Successful deletion, return the nil sector with no errors
        {
          sector: sector,
          errors: []
        }
      else
        # Failed delete, return the errors to the client
        {
          sector: nil,
          errors: sector.errors.full_messages
        }
      end
    end
  end
end
