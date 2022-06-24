# frozen_string_literal: true

require 'modules/slugger'

module Mutations
  class CreateSpreadsheetData < Mutations::BaseMutation
    include Modules::Slugger

    argument :spreadsheet_data, GraphQL::Types::JSON, required: false, default_value: []
    argument :spreadsheet_type, String, required: true
    argument :assoc, String, required: false, default_value: ''
    argument :row_index, Int, required: false

    field :dial_spreadsheet_data, Types::DialSpreadsheetDataType, null: true
    field :errors, [String], null: false

    def resolve(spreadsheet_data:, spreadsheet_type:, assoc:, row_index:)
      unless an_admin
        return {
          dial_spreadsheet_data: nil,
          errors: ['Not allowed to create a spreadsheet data.']
        }
      end

      if row_index == 0
        case assoc.downcase
        when 'descriptions'
          DialSpreadsheetData.where(spreadsheet_type: spreadsheet_type).each do |spreadsheet_record|
            spreadsheet_record.spreadsheet_data['descriptions'] = []
            spreadsheet_record.save!
          end
        when 'organizations'
          DialSpreadsheetData.where(spreadsheet_type: spreadsheet_type).each do |spreadsheet_record|
            spreadsheet_record.spreadsheet_data['organizations'] = []
            spreadsheet_record.save!
          end
        when 'sdgs'
          DialSpreadsheetData.where(spreadsheet_type: spreadsheet_type).each do |spreadsheet_record|
            spreadsheet_record.spreadsheet_data['sdgs'] = []
            spreadsheet_record.save!
          end
        when 'sectors'
          DialSpreadsheetData.where(spreadsheet_type: spreadsheet_type).each do |spreadsheet_record|
            spreadsheet_record.spreadsheet_data['sectors'] = []
            spreadsheet_record.save!
          end
        end
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

    def update_spreadsheet_data(existing_data, spreadsheet_data, assoc)
      updated_data = existing_data

      if updated_data.nil? || updated_data.empty?
        updated_data = { 'descriptions': [], 'organizations': [], 'sdgs': [], 'sectors': [] }
      end

      changes_data = spreadsheet_data['changes']

      changes_data.each_with_index do |change, column_index|
        case assoc.downcase
        when 'products'
          updated_data['name'] = spreadsheet_data['name']
          case column_index
          when 1
            updated_data['aliases'] = change
          when 2
            updated_data['website'] = change
          when 3
            updated_data['license'] = change
          when 4
            updated_data['type'] = change
          when 5
            updated_data['tags'] = change
          when 6
            updated_data['submitterName'] = change
          when 7
            updated_data['submitterEmail'] = change
          end
        when 'datasets'
          updated_data['name'] = spreadsheet_data['name']
          case column_index
          when 1
            updated_data['aliases'] = change
          when 2
            updated_data['website'] = change
          when 3
            updated_data['origins'] = change
          when 4
            updated_data['endorsers'] = change
          when 5
            updated_data['license'] = change
          when 6
            updated_data['type'] = change
          when 7
            updated_data['tags'] = change
          when 8
            updated_data['format'] = change
          when 9
            updated_data['comments'] = change
          when 10
            updated_data['geographicCoverage'] = change
          when 11
            updated_data['timeRange'] = change
          when 12
            updated_data['visualizationUrl'] = change
          end
        when 'descriptions'
          if column_index == 2
            product_description = updated_data['descriptions'].find { |d| d['locale'] == spreadsheet_data['locale'] }
            if product_description.nil?
              product_description = { 'locale': spreadsheet_data['locale'] }
            end
            product_description['description'] = change
            updated_data['descriptions'] << product_description
          end
        when 'organizations'
          new_org = { 'name': change }
          updated_data['organizations'] << new_org if !updated_data['organizations'].any? do |h|
                                                        h['name'] == change
                                                      end && column_index == 1
          # updated_data['organizations'].delete_if { |e| e['name'] == changes_data[2] }
        when 'sdgs'
          if column_index == 1
            change.split(',').each do |sdg_num|
              updated_data['sdgs'] << { 'number': sdg_num } unless updated_data['sdgs'].any? do |h|
                                                                     h['number'] == sdg_num
                                                                   end
            end
          end
          # updated_data['sdgs'].delete_if { |e| e['name'] == changes_data[2] }
        when 'sectors'
          new_sector = { 'name': change }
          updated_data['sectors'] << new_sector if !updated_data['sectors'].any? do |h|
                                                     h['name'] == change
                                                   end && column_index == 1
          # updated_data['sectors'].delete_if { |e| e['name'] == changes_data[2] }
        end
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
