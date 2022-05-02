# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateOrganization < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true
    argument :slug, String, required: true
    argument :aliases, GraphQL::Types::JSON, required: false
    argument :website, String, required: false
    argument :is_endorser, Boolean, required: false, default_value: false
    argument :when_endorsed, GraphQL::Types::ISO8601Date, required: false
    argument :endorser_level, String, required: false
    argument :is_mni, Boolean, required: false, default_value: false

    field :organization, Types::OrganizationType, null: true
    field :errors, [String], null: true

    def resolve(name:, slug:, aliases: nil, website: nil, is_endorser: nil, when_endorsed: nil, endorser_level: nil,
      is_mni: nil)
      unless an_admin
        return {
          organization: nil,
          errors: ['Must be admin to create an organization']
        }
      end

      organization = Organization.find_by(slug: slug)

      if organization.nil?
        organization = Organization.new(name: name)
        organization.slug = slug_em(name)

        if Organization.where(slug: slug_em(name)).count.positive?
          # Check if we need to add _dup to the slug.
          first_duplicate = Organization.slug_starts_with(slug_em(name)).order(slug: :desc).first
          organization.slug = organization.slug + generate_offset(first_duplicate) unless first_duplicate.nil?
        end
      end

      # Re-slug if the name is updated (not the same with the one in the db).
      if organization.name != name
        organization.name = name
        organization.slug = slug_em(name)

        if Organization.where(slug: slug_em(name)).count.positive?
          # Check if we need to add _dup to the slug.
          first_duplicate = Organization.slug_starts_with(organization.slug).order(slug: :desc).first
          organization.slug = organization.slug + generate_offset(first_duplicate) unless first_duplicate.nil?
        end
      end

      organization.aliases = aliases
      organization.website = website
      organization.is_endorser = is_endorser
      organization.when_endorsed = when_endorsed
      organization.endorser_level = endorser_level
      organization.is_mni = is_mni

      if organization.save
        organization_desc = OrganizationDescription.find_by(organization_id: organization.id, locale: I18n.locale)
        organization_desc = OrganizationDescription.new if organization_desc.nil?
        organization_desc.organization_id = organization.id
        organization_desc.locale = I18n.locale
        organization_desc.save

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

    def generate_offset(first_duplicate)
      size = 1
      unless first_duplicate.nil?
        size = first_duplicate.slug
                              .slice(/_dup\d+$/)
                              .delete('^0-9')
                              .to_i + 1
      end
      "_dup#{size}"
    end
  end
end
