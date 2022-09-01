# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class DeleteSpreadsheetData < Mutations::BaseMutation
    include Modules::Slugger

    argument :spreadsheet_data, GraphQL::Types::JSON, required: false, default_value: {}
    argument :spreadsheet_type, String, required: true
    argument :assoc, String, required: false, default_value: ''

    field :dial_spreadsheet_data, Types::DialSpreadsheetDataType, null: true
    field :errors, [String], null: false

    PRICING_FIELDS = ['assoc-name', 'hostingModel', 'pricingModel', 'pricingDetails', 'pricingDatetime', 'pricingUrl']

    def resolve(spreadsheet_data:, spreadsheet_type:, assoc:)
      unless an_admin
        return {
          dial_spreadsheet_data: nil,
          errors: ['Not allowed to create a spreadsheet data.']
        }
      end

      slug = slug_em(spreadsheet_data['name'])
      existing_data = DialSpreadsheetData.find_by(slug: slug, spreadsheet_type: spreadsheet_type)

      case assoc
      when 'productPricing'
        PRICING_FIELDS.each do |pricing_field|
          existing_data.spreadsheet_data[PRICING_FIELDS[pricing_field]] = nil
        end
      when 'descriptions'
        changes_data = spreadsheet_data['changes']
        existing_data.spreadsheet_data[assoc].delete_if do |description|
          description['locale'] == changes_data[1] && description['description'] == changes_data[2]
        end
      when 'sdgs'
        update_relationship_data(existing_data, spreadsheet_data, assoc, 'number')
      when 'organizations', 'sectors', 'buildingBlocks', 'useCasesSteps'
        # Handle sectors + organizations here because the field name is the same.
        update_relationship_data(existing_data, spreadsheet_data, assoc, 'name')
      end

      dbop_success = false
      if assoc.downcase == 'products' || assoc.downcase == 'datasets'
        dbop_success = existing_data.destroy
      else
        dbop_success = existing_data.save
      end

      if dbop_success
        # Successful creation, return the created object with no errors
        {
          dial_spreadsheet_data: existing_data,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          dial_spreadsheet_data: nil,
          errors: existing_data.errors.full_messages
        }
      end
    end

    def update_relationship_data(existing_data, spreadsheet_data, assoc, field_name)
      changes_data = spreadsheet_data['changes']
      existing_data.spreadsheet_data[assoc].delete_if { |description| description[field_name] == changes_data[1] }
    end
  end
end
