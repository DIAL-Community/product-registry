# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class UpdateOrganizationOffices < Mutations::BaseMutation
    include Modules::Slugger

    argument :offices, [GraphQL::Types::JSON], required: true
    argument :slug, String, required: true

    field :organization, Types::OrganizationType, null: true
    field :errors, [String], null: true

    def resolve(offices:, slug:)
      organization = Organization.find_by(slug: slug)

      unless an_admin || an_org_owner(organization.id)
        return {
          organization: nil,
          errors: ['Must be admin or organization owner to update an organization']
        }
      end

      organization.offices = []
      offices&.each do |office|
        slug_string = "#{organization.name} #{office['cityName']} #{office['regionName']} #{office['countryCode']}"
        office_slug = slug_em(slug_string)
        current_office = Office.find_by(slug: office_slug)
        if current_office.nil?
          current_office = create_new_office(office, office_slug)
          current_office.organization_id = organization.id
        end
        organization.offices << current_office
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

    def create_new_office(office, office_slug)
      name_string = office['cityName'] + ", " + office['regionName'] + ", " + office['countryCode']
      new_office = Office.new(name: name_string)
      new_office.latitude = office['latitude']
      new_office.longitude = office['longitude']
      new_office.city = office['cityName']

      country = Country.find_by(name: office['countryName'])

      region = Region.find_by(name: office['regionName'])
      if region.nil?
        region = create_new_region(office, country)
        region.save
      end

      new_office.country_id = country.id
      new_office.region_id = region.id

      new_office.slug = office_slug

      # Check if we need to add _dup to the slug.
      first_duplicate = Office.slug_simple_starts_with(office_slug).order(slug: :desc).first
      if !first_duplicate.nil?
        new_office.slug = office_slug + generate_offset(first_duplicate)
      else
        new_office.slug = office_slug
      end
      new_office
    end

    def create_new_region(office, country)
      region = Region.new(name: office['regionName'])
      region.latitude = office['latitude']
      region.longitude = office['longitude']
      region.country_id = country.id

      region_slug = slug_em(office['regionName'])

      # Check if we need to add _dup to the slug.
      first_duplicate = Region.slug_simple_starts_with(region_slug).order(slug: :desc).first
      if !first_duplicate.nil?
        region.slug = region_slug + generate_offset(first_duplicate)
      else
        region.slug = region_slug
      end
      region
    end
  end
end
