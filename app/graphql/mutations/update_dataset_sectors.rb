# frozen_string_literal: true

module Mutations
  class UpdateDatasetSectors < Mutations::BaseMutation
    argument :sector_slugs, [String], required: true
    argument :slug, String, required: true

    field :dataset, Types::DatasetType, null: true
    field :errors, [String], null: true

    def resolve(sector_slugs:, slug:)
      dataset = Dataset.find_by(slug: slug)

      unless an_admin
        return {
          dataset: nil,
          errors: ['Must be admin to update an dataset']
        }
      end

      dataset.sectors = []
      if !sector_slugs.nil? && !sector_slugs.empty?
        sector_slugs.each do |sector_slug|
          # Potentially returning multiple sectors here.
          sectors = Sector.where("slug in (?)", sector_slug)
          # This will actually create non-array-of-array. Surprisingly!
          dataset.sectors << sectors unless sectors.nil?
        end
      end

      if dataset.save
        # Successful creation, return the created object with no errors
        {
          dataset: dataset,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          dataset: nil,
          errors: dataset.errors.full_messages
        }
      end
    end
  end
end
