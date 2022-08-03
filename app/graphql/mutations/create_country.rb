# frozen_string_literal: true

require 'modules/slugger'
require 'modules/geocode'

module Mutations
  class CreateCountry < Mutations::BaseMutation
    include Modules::Slugger
    include Modules::Geocode

    argument :name, String, required: true
    argument :slug, String, required: false

    argument :code, String, required: false
    argument :code_longer, String, required: false

    field :country, Types::CountryType, null: true
    field :errors, [String], null: true

    def resolve(name:, slug: nil, code: nil, code_longer: nil)
      unless an_admin || a_content_editor
        return {
          country: nil,
          errors: ['Must be admin or content editor to create a country.']
        }
      end

      country = Country.find_by(name: name)
      country = Country.find_by(slug: slug) if country.nil? && !slug.nil?
      country = Country.find_by(code: code) if country.nil? && !code.nil?
      country = Country.find_by(code_longer: code_longer) if country.nil? && !code_longer.nil?

      country_lookup_data = YAML.load_file('config/country_lookup.yml')

      if country.nil?
        google_auth_key = Rails.application.secrets.google_api_key
        country_data = JSON.parse(geocode_with_google(name, name, google_auth_key))

        country_data['results'].each do |country_result|
          # Skip the next result if we already find our country data.
          next unless country.nil?

          country_result['address_components'].each do |address_component|
            # We're only reading the country name and country name type will always political.
            next unless address_component['types'].include?('political')

            # Country name and the 2 character country code from geocode result.
            # See geocode data example below.
            country_name = address_component['long_name']
            country_code = address_component['short_name']
            next if country_code.nil?

            country = Country.find_by(name: country_name, code: country_code)
            country = Country.new(
              name: country_name,
              slug: slug_em(country_code),
              code: country_code
            ) if country.nil?

            unless country.nil?
              country.latitude = country_result['geometry']['location']['lat']
              country.longitude = country_result['geometry']['location']['lng']
            end
          end
        end

        if country.nil?
          return {
            country: nil,
            errors: ['Unable to resolve known country data.']
          }
        end
      end

      # Geocode data doesn't return the 3 char country code. Use the UN lookup table.
      # See: https://unstats.un.org/unsd/methodology/m49/
      # See: https://www.iban.com/country-codes
      country_yml = lookup_country_by_code(country_lookup_data, country.code)
      unless country_yml.nil?
        country.code_longer = country_yml['country_code']
      end

      if country.save
        # Successful creation, return the created object with no errors
        {
          country: country,
          errors: []
        }
      else
        # Failed save, return the errors to the client.
        {
          country: nil,
          errors: country.errors.full_messages
        }
      end
    end

    def lookup_country_by_code(country_lookup_data, country_code)
      puts "Searching: #{country_code}."
      country_lookup_data['countries'].each do |lookup_country|
        if lookup_country['country_code_short'] == country_code
          return lookup_country
        end
      end
    end
  end
end

# Example of the geocode output for country.
# https://maps.googleapis.com/maps/api/geocode/json?region=Kenya&address=Kenya&key=API_KEY
# {
# 	"results": [
# 		{
# 			"address_components": [
# 				{
# 					"long_name": "Kenya",
# 					"short_name": "KE",
# 					"types": [
# 						"country",
# 						"political"
# 					]
# 				}
# 			],
# 			"formatted_address": "Kenya",
# 			"geometry": {
# 				"bounds": {
# 					"northeast": {
# 						"lat": 5.033420899999999,
# 						"lng": 41.9069449
# 					},
# 					"southwest": {
# 						"lat": -4.724299999999999,
# 						"lng": 33.90982109999999
# 					}
# 				},
# 				"location": {
# 					"lat": -0.023559,
# 					"lng": 37.906193
# 				},
# 				"location_type": "APPROXIMATE",
# 				"viewport": {
# 					"northeast": {
# 						"lat": 5.033420899999999,
# 						"lng": 41.9069449
# 					},
# 					"southwest": {
# 						"lat": -4.724299999999999,
# 						"lng": 33.90982109999999
# 					}
# 				}
# 			},
# 			"place_id": "ChIJD5BQg9CAJxgR2W2XobAOO0A",
# 			"types": [
# 				"country",
# 				"political"
# 			]
# 		}
# 	],
# 	"status": "OK"
# }
