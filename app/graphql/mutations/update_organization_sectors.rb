# frozen_string_literal: true

module Mutations
  class UpdateOrganizationSectors < Mutations::BaseMutation
    argument :sectors_slugs, [String], required: true
    argument :slug, String, required: true

    field :organization, Types::OrganizationType, null: true
    field :errors, [String], null: true

    def resolve(sectors_slugs:, slug:)
      unless an_admin
        return {
          organization: nil,
          errors: ['Must be admin to create an organization']
        }
      end

      organization = Organization.find_by(slug: slug)

      organization.sectors = []
      if !sectors_slugs.nil? && !sectors_slugs.empty?
        sectors_slugs.each do |sector_slug|
          current_sector = Sector.find_by(slug: sector_slug)
          unless current_sector.nil?
            organization.sectors << current_sector
          end
        end
      end

      if organization.save
        # Successful creation, return the created object with no errors
        {
          organization: organization,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          organization: nil,
          errors: organization.errors.full_messages
        }
      end
    end
  end
end
