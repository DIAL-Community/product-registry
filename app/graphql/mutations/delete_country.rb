# frozen_string_literal: true

module Mutations
  class DeleteCountry < Mutations::BaseMutation
    argument :id, ID, required: true

    field :country, Types::CountryType, null: true
    field :errors, [String], null: true

    def resolve(id:)
      unless an_admin
        return {
          country: nil,
          errors: ['Must be admin to delete a country.']
        }
      end

      country = Country.find_by(id: id)
      if country.nil?
        return {
          country: nil,
          errors: ['Unable to uniquely identify country to delete.']
        }
      end

      ActiveRecord::Base.transaction do
        if country.destroy
          # Successful deletion, return the nil country with no errors
          return {
            country: country,
            errors: []
          }
        end
      end
      # Failed delete, return the errors to the client.
      # We will only reach this block if the transaction is failed.
      {
        country: nil,
        errors: country.errors.full_messages
      }
    end
  end
end
