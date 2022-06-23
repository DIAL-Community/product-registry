# frozen_string_literal: true

module Mutations
  class UpdateDatasetTags < Mutations::BaseMutation
    argument :tag_names, [String], required: true
    argument :slug, String, required: true

    field :dataset, Types::DatasetType, null: true
    field :errors, [String], null: true

    def resolve(tag_names:, slug:)
      dataset = Dataset.find_by(slug: slug)

      unless an_admin
        return {
          dataset: nil,
          errors: ['Must be admin to update an dataset']
        }
      end

      dataset.tags = []
      if !tag_names.nil? && !tag_names.empty?
        tag_names.each do |tag_name|
          tag = Tag.find_by(name: tag_name)
          dataset.tags << tag.name unless tag.nil?
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
