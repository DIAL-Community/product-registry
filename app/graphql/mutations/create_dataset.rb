# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateDataset < Mutations::BaseMutation
    include Modules::Slugger

    argument :name, String, required: true
    argument :slug, String, required: true
    argument :aliases, GraphQL::Types::JSON, required: false
    argument :website, String, required: false
    argument :visualization_url, String, required: false
    argument :geographic_coverage, String, required: false
    argument :time_range, String, required: false
    argument :license, String, required: false
    argument :languages, String, required: false
    argument :data_format, String, required: false
    argument :dataset_type, String, required: true
    argument :description, String, required: true

    field :dataset, Types::DatasetType, null: true
    field :errors, [String], null: true

    def resolve(name:, slug:, aliases:, website:, visualization_url:, geographic_coverage:,
      time_range:, dataset_type:, license:, languages:, data_format:, description:)
      dataset = Dataset.find_by(slug: slug)

      if dataset.nil?
        dataset = Dataset.new(name: name)
        dataset.slug = slug_em(name)

        if Dataset.where(slug: slug_em(name)).count.positive?
          # Check if we need to add _dup to the slug.
          first_duplicate = Dataset.slug_starts_with(slug_em(name)).order(slug: :desc).first
          dataset.slug = dataset.slug + generate_offset(first_duplicate) unless first_duplicate.nil?
        end
      end

      unless an_admin || an_org_owner(dataset.id)
        return {
          dataset: nil,
          errors: ['Must be admin or dataset owner to create an dataset']
        }
      end

      dataset.name = name
      dataset.aliases = aliases
      dataset.website = website
      dataset.dataset_type = dataset_type
      dataset.visualization_url = visualization_url
      dataset.geographic_coverage = geographic_coverage
      dataset.time_range = time_range
      dataset.license = license
      dataset.languages = languages
      dataset.data_format = data_format

      if dataset.save!
        dataset_desc = DatasetDescription.find_by(dataset_id: dataset.id, locale: I18n.locale)
        dataset_desc = DatasetDescription.new if dataset_desc.nil?
        dataset_desc.description = description
        dataset_desc.dataset_id = dataset.id
        dataset_desc.locale = I18n.locale
        if dataset_desc.save!
          puts "Dataset description for: #{dataset.name} with locale: #{I18n.locale} saved."
        end

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
