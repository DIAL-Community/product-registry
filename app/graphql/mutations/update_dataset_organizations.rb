# frozen_string_literal: true

module Mutations
  class UpdateDatasetOrganizations < Mutations::BaseMutation
    argument :organization_slugs, [String], required: true
    argument :slug, String, required: true

    field :dataset, Types::DatasetType, null: true
    field :errors, [String], null: true

    def resolve(organization_slugs:, slug:)
      dataset = Dataset.find_by(slug: slug)

      unless an_admin
        return {
          dataset: nil,
          errors: ['Must be admin to update an dataset']
        }
      end

      dataset.organizations_datasets = []
      if !organization_slugs.nil? && !organization_slugs.empty?
        organization_slugs.each do |organization_slug|
          organization = Organization.find_by(slug: organization_slug)
          next if organization.nil?

          organization_dataset = OrganizationsDataset.new
          organization_dataset.organization = organization
          organization_dataset.dataset = dataset
          organization_dataset.association_source = OrganizationsProduct.RIGHT

          dataset.organizations_datasets << organization_dataset
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
