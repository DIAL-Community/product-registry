# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateSpreadsheetData < Mutations::BaseMutation
    include Modules::Slugger

    argument :spreadsheet_data, GraphQL::Types::JSON, required: false, default_value: []
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
      end

      record.spreadsheet_type = spreadsheet_type
      record.spreadsheet_data = update_spreadsheet_data(record.spreadsheet_data, spreadsheet_data, assoc)

      if record.save
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

    def update_spreadsheet_data(existing_data, spreadsheet_data, assoc)
      updated_data = existing_data

      if updated_data.nil? || updated_data.empty?
        updated_data = { 'descriptions': [], 'organizations': [], 'sdgs': [], 'sectors': [] }
      end

      changes_data = spreadsheet_data['changes']

      case assoc.downcase
      when 'products'
        updated_data['name'] = spreadsheet_data['name']
        column_index = changes_data[1].to_i
        case column_index
        when 1
          updated_data['aliases'] = changes_data[3]
        when 2
          updated_data['website'] = changes_data[3]
        when 3
          updated_data['license'] = changes_data[3]
        when 4
          updated_data['type'] = changes_data[3]
        when 5
          updated_data['tags'] = changes_data[3]
        when 6
          updated_data['submitterName'] = changes_data[3]
        when 7
          updated_data['submitterEmail'] = changes_data[3]
        end
      when 'datasets'
        updated_data['name'] = spreadsheet_data['name']
        column_index = changes_data[1].to_i
        case column_index
        when 1
          updated_data['aliases'] = changes_data[3]
        when 2
          updated_data['website'] = changes_data[3]
        when 3
          updated_data['origins'] = changes_data[3]
        when 4
          updated_data['endorsers'] = changes_data[3]
        when 5
          updated_data['license'] = changes_data[3]
        when 6
          updated_data['type'] = changes_data[3]
        when 7
          updated_data['tags'] = changes_data[3]
        when 8
          updated_data['format'] = changes_data[3]
        when 9
          updated_data['comments'] = changes_data[3]
        end
      when 'descriptions'
        product_description = updated_data['descriptions'].find { |d| d['locale'] == spreadsheet_data['locale'] }
        if product_description.nil?
          product_description = { 'locale': spreadsheet_data['locale'] }
          updated_data['descriptions'] << product_description
        end
        product_description['description'] = changes_data[3] if changes_data[1].to_i == 2
      when 'organizations'
        updated_data['organizations'] << { 'name': changes_data[3] }
        updated_data['organizations'].delete_if { |e| e['name'] == changes_data[2] }
      when 'sdgs'
        updated_data['sdgs'] << { 'name': changes_data[3] }
        updated_data['sdgs'].delete_if { |e| e['name'] == changes_data[2] }
      when 'sectors'
        updated_data['sectors'] << { 'name': changes_data[3] }
        updated_data['sectors'].delete_if { |e| e['name'] == changes_data[2] }
      end

      updated_data
    end

    def generate_offset(first_duplicate)
      size = 1
      unless first_duplicate.nil?
        size = first_duplicate.slug
                              .slice(/_dup\d+$/)
                              .delete('^0-9')
                              .to_i + 1
      end
      "_dup#{size}"
    end
  end
end
