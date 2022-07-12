# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateBuildingBlock < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true
    argument :slug, String, required: true
    argument :description, String, required: true
    argument :maturity, String, required: true
    argument :spec_url, String, required: false
    argument :image_file, ApolloUploadServer::Upload, required: false

    field :building_block, Types::BuildingBlockType, null: true
    field :errors, [String], null: true

    def resolve(name:, slug:, description:, maturity:, spec_url:, image_file: nil)
      unless an_admin || a_content_editor
        return {
          building_block: nil,
          errors: ['Must be admin or content editor to create building block']
        }
      end

      building_block = BuildingBlock.find_by(slug: slug)

      if building_block.nil?
        building_block = BuildingBlock.new(name: name)
        slug = slug_em(name)

        # Check if we need to add _dup to the slug.
        first_duplicate = BuildingBlock.slug_simple_starts_with(slug).order(slug: :desc).first
        if !first_duplicate.nil?
          building_block.slug = slug + generate_offset(first_duplicate)
        else
          building_block.slug = slug
        end
      end

      # allow user to rename use case but don't re-slug it
      building_block.name = name
      building_block.maturity = maturity
      building_block.spec_url = spec_url

      if building_block.save
        unless image_file.nil?
          uploader = LogoUploader.new(building_block, image_file.original_filename, context[:current_user])
          begin
            uploader.store!(image_file)
          rescue StandardError => e
            puts "Unable to save image for: #{building_block.name}. Standard error: #{e}."
          end
          building_block.auditable_image_changed(image_file.original_filename)
        end

        building_block_desc = BuildingBlockDescription.find_by(id: building_block.id, locale: I18n.locale)
        building_block_desc = BuildingBlockDescription.new if building_block_desc.nil?
        building_block_desc.description = description
        building_block_desc.building_block_id = building_block.id
        building_block_desc.locale = I18n.locale
        building_block_desc.save

        # Successful creation, return the created object with no errors
        {
          building_block: building_block,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          building_block: nil,
          errors: building_block.errors.full_messages
        }
      end
    end
  end
end
