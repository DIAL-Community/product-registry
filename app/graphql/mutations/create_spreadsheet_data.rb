# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateSpreadsheetData < Mutations::BaseMutation
    include Modules::Slugger

    argument :spreadsheet_data, GraphQL::Types::JSON, required: false, default_value: {}
    argument :spreadsheet_type, String, required: true
    argument :assoc, String, required: false, default_value: ''

    field :dial_spreadsheet_data, Types::DialSpreadsheetDataType, null: true
    field :errors, [String], null: false

    def resolve(spreadsheet_data:, spreadsheet_type:, assoc:)
      unless an_admin
        return {
          dial_spreadsheet_data: nil,
          errors: ['Not allowed to create a spreadsheet data.']
        }
      end

      slug = slug_em(spreadsheet_data['name'])
      record = DialSpreadsheetData.find_by(slug: slug, spreadsheet_type: spreadsheet_type)
      if record.nil? && assoc != 'products' && assoc != 'datasets'
        # Trying to update association when we don't have the base spreadsheet record yet.
        return {
          dial_spreadsheet_data: nil,
          errors: ['Base elements needed before updating the record.']
        }
      end

      if record.nil?
        record = DialSpreadsheetData.new(slug: slug)

        # Check if we need to add _dup to the slug.
        first_duplicate = DialSpreadsheetData.slug_simple_starts_with(record.slug).order(slug: :desc).first
        unless first_duplicate.nil?
          record.slug = record.slug + generate_offset(first_duplicate)
        end
      end

      record.spreadsheet_type = spreadsheet_type
      record.spreadsheet_data = update_spreadsheet_data(record.spreadsheet_data, spreadsheet_data, assoc)

      if record.save!
        # Successful creation, return the created object with no errors
        {
          dial_spreadsheet_data: record,
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          dial_spreadsheet_data: nil,
          errors: dial_spreadsheet_data.errors.full_messages
        }
      end
    end

    # Column field is starting from the second field on the spreadsheet. The first column always going to be the
    # name of the object (product name or dataset name).
    DESCRIPTION_FIELDS = ['assoc-name', 'locale', 'description']

    PRICING_FIELDS = ['assoc-name', 'hostingModel', 'pricingModel', 'pricingDetails', 'pricingDatetime', 'pricingUrl']

    PRODUCT_FIELDS = ['name', 'aliases', 'website', 'license', 'tags', 'submitterName', 'submitterEmail']
    DATASET_FIELDS = [
      'name', 'aliases', 'website', 'origins', 'endorsers', 'license', 'tags', 'format', 'comments',
      'geographicCoverage', 'timeRange', 'visualizationUrl', 'languages'
    ]

    MULTI_VALUE_SEPARATOR = ';'

    def update_spreadsheet_data(existing_data, spreadsheet_data, assoc)
      updated_data = existing_data
      changes_data = spreadsheet_data['changes']

      case assoc
      # Association coming from 'Product Pricing' sheet.
      when 'productPricing'
        # Skip if the update is from the first column of the pricing.
        pricing_column_index = changes_data[1].to_i
        updated_data[PRICING_FIELDS[pricing_column_index]] = changes_data[3] if pricing_column_index > 0
      # Association is products / coming from 'Products' sheet.
      when 'products'
        changes_data.each_with_index do |change, column_index|
          # Special handling because the field is a boolean one.
          if column_index == PRODUCT_FIELDS.length
            updated_data['commercialProduct'] = change.to_s == 'true'
          else
            updated_data[PRODUCT_FIELDS[column_index]] = change
          end
        end
      # Association is dataset / coming from 'Datasets' sheet.
      when 'datasets'
        changes_data.each_with_index do |change, column_index|
          updated_data[DATASET_FIELDS[column_index]] = change
        end
      when 'descriptions'
        column_index = changes_data[1].to_i
        previous_value = changes_data[2]
        current_value = changes_data[3]

        if existing_data[assoc].nil?
          # Initialize if we don't have the association yet.
          existing_data[assoc] = []
        end

        field_name = DESCRIPTION_FIELDS[column_index]
        existing_assoc = existing_data['descriptions'].find { |entry| entry[field_name].to_s == previous_value.to_s }
        if existing_assoc.nil?
          existing_data['descriptions'] << { "#{field_name}": current_value.strip }
        else
          existing_assoc[field_name] = current_value
        end
      when 'sdgs'
        process_relationship_data(updated_data, spreadsheet_data, assoc, 'number')
      when 'organizations', 'sectors', 'buildingBlocks', 'useCasesSteps'
        process_relationship_data(updated_data, spreadsheet_data, assoc, 'name')
      end

      updated_data
    end

    # Process the rest of the association ('organizations', 'sdgs', 'sectors')
    def process_relationship_data(existing_data, spreadsheet_data, assoc, field_name)
      if existing_data[assoc].nil?
        # Initialize if we don't have the association yet.
        existing_data[assoc] = []
      end

      changes_data = spreadsheet_data['changes']
      current_value = changes_data[3]
      if current_value.to_s.include?(MULTI_VALUE_SEPARATOR)
        current_value.to_s.split(MULTI_VALUE_SEPARATOR).each do |current_value_el|
          # Skip if the value is already in the array.
          next if current_value_el.blank?
          next if existing_data[assoc].any? { |o| o[field_name] == current_value_el.strip }

          existing_data[assoc] << { "#{field_name}": current_value_el.strip }
        end
      else
        unless current_value.is_a?(Integer)
          # Strip the value just in case it is a string with a lot of spaces!!
          current_value = current_value.strip
        end

        previous_value = changes_data[2]
        existing_assoc = existing_data[assoc].find { |entry| entry[field_name].to_s == previous_value.to_s }
        if existing_assoc.nil?
          existing_data[assoc] << { "#{field_name}": current_value }
        else
          existing_assoc[field_name] = current_value
        end
      end
    end
  end
end
