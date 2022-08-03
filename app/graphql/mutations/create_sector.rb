# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateSector < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true
    argument :slug, String, required: true
    argument :origin_id, Integer, required: true
    argument :parent_sector_id, Integer, required: false
    argument :is_displayable, Boolean, required: true

    field :sector, Types::SectorType, null: true
    field :errors, [String], null: true

    def resolve(name:, slug:, origin_id:, parent_sector_id:, is_displayable:)
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

      # Update field of the sector object
      sector.name = name
      sector.locale = I18n.locale
      sector.origin_id = origin_id
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
