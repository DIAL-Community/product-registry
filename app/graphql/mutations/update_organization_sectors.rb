# frozen_string_literal: true

module Mutations
  class UpdateOrganizationSectors < Mutations::BaseMutation
    argument :sectors_slugs, [String], required: true
    argument :slug, String, required: true

    field :organization, Types::OrganizationType, null: true
    field :errors, [String], null: true

    def resolve(sectors_slugs:, slug:)
      organization = Organization.find_by(slug: slug)

      unless an_admin || an_org_owner(organization.id)
        return {
          organization: nil,
          errors: ['Must be admin or organization owner to update an organization']
        }
      end

      organization.sectors = []
      if !sectors_slugs.nil? && !sectors_slugs.empty?
        sectors_slugs.each do |sector_slug|
          current_sector = Sector.where(slug: sector_slug, is_displayable: true)
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
