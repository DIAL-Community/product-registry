# frozen_string_literal: true

module Mutations
  class UpdateDatasetSdgs < Mutations::BaseMutation
    argument :sdg_slugs, [String], required: true
    argument :mapping_status, String, required: true
    argument :slug, String, required: true

    field :dataset, Types::DatasetType, null: true
    field :errors, [String], null: true

    def resolve(sdg_slugs:, mapping_status:, slug:)
      dataset = Dataset.find_by(slug: slug)

      unless an_admin
        return {
          dataset: nil,
          errors: ['Must be admin to update an dataset']
        }
      end

      dataset.dataset_sustainable_development_goals = []
      if !sdg_slugs.nil? && !sdg_slugs.empty?
        sdg_slugs.each do |sdg_slug|
          sdg = SustainableDevelopmentGoal.find_by(slug: sdg_slug)
          next if sdg.nil?

          dataset_sdg = DatasetSustainableDevelopmentGoal.new
          dataset_sdg.dataset = dataset
          dataset_sdg.sustainable_development_goal = sdg
          dataset_sdg.association_source = DatasetSustainableDevelopmentGoal.RIGHT
          dataset_sdg.mapping_status = mapping_status

          dataset.dataset_sustainable_development_goals << dataset_sdg
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
