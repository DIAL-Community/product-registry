# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class UpdateOrganizationCountry < Mutations::BaseMutation
    include Modules::Slugger

    argument :countries_slugs, [String], required: true
    argument :slug, String, required: true

    field :organization, Types::OrganizationType, null: true
    field :errors, [String], null: true

    def resolve(countries_slugs:, slug:)
      organization = Organization.find_by(slug: slug)

      organization.countries = []
      if !countries_slugs.nil? && !countries_slugs.empty?
        countries_slugs.each do |country_slug|
          current_country = Country.find_by(slug: country_slug)
          organization.countries << current_country
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
