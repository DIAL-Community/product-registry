# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateSector < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true
    argument :slug, String, required: true
    argument :origin_id, Integer, required: false, default_value: nil
    argument :parent_sector_id, Integer, required: false, default_value: nil
    argument :is_displayable, Boolean, required: true
    argument :locale, String, required: false, default_value: nil

    field :sector, Types::SectorType, null: true
    field :errors, [String], null: true

    def resolve(name:, slug:, origin_id:, parent_sector_id:, is_displayable:, locale:)
      unless an_admin || a_content_editor
        return {
          sector: nil,
          errors: ['Must be admin or content editor to create an sector']
        }
      end

      sector = Sector.find_by(slug: slug)
      if sector.nil?
        sector = Sector.new(name: name, slug: slug_em(name))

        # Check if we need to add _dup to the slug.
        first_duplicate = Sector.slug_simple_starts_with(sector.slug).order(slug: :desc).first
        unless first_duplicate.nil?
          sector.slug = sector.slug + generate_offset(first_duplicate)
        end
      end

      sector_locale = locale
      if sector_locale.nil? || !I18n.available_locales.map(&:to_s).include?(sector_locale)
        # Default to the current user locale if there's no locale value or the locale is unknown.
        sector_locale = I18n.locale
      end

      sector_origin_id = origin_id
      if sector_origin_id.nil? || Origin.find_by(id: sector_origin_id).nil?
        # This origin is added through seeds.rb. Defaulting to this if the origin from the UI is nil
        # or the user entered random origin value.
        origin = Origin.find_by(slug: 'manually_entered')
        sector_origin_id = origin.id
      end

      # Update field of the sector object
      sector.name = name
      sector.locale = sector_locale
      sector.origin_id = sector_origin_id
      sector.parent_sector_id = parent_sector_id
      sector.is_displayable = is_displayable

      if sector.save
        # Successful creation, return the created object with no errors
        {
          sector: sector,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          sector: nil,
          errors: sector.errors.full_messages
        }
      end
    end
  end
end
