# frozen_string_literal: true

require 'modules/slugger'
require 'modules/geocode'

module Mutations
  class CreateCountry < Mutations::BaseMutation
    include Modules::Slugger
    include Modules::Geocode

    argument :name, String, required: true
    argument :slug, String, required: false

    field :country, Types::CountryType, null: true
    field :errors, [String], null: true

    def resolve(name:, slug: nil)
      unless an_admin || a_content_editor
        return {
          country: nil,
          errors: ['Must be admin or content editor to create a country.']
        }
      end

      # Find existing country record.
      country = Country.find_by(name: name)
      country = Country.find_by(slug: slug) if country.nil? && !slug.nil?

      # Read our country lookup YAML file. The file will have the 3 alphas country code.
      country_lookup_data = YAML.load_file('config/country_lookup.yml')

      google_auth_key = Rails.application.secrets.google_api_key
      country_data = JSON.parse(geocode_with_google(name, name, google_auth_key))

      # After all the reverse geocode, we still can't find country?
      if country_data['results'].empty?
        return {
          country: nil,
          errors: ['Unable to resolve known country data.']
        }
      end

      country_data['results'].each do |country_result|
      address_component = country_result['address_components'].first
        # We're only reading the country name and country name type will always political.
        next unless address_component['types'].include?('political')

        # Country name and the 2 character country code from geocode result.
        # See geocode data example below.
        country_name = address_component['long_name']
        country_code = address_component['short_name']
        next if country_code.nil?

        # Create new country if we can't find country by the name or slug.
        country = Country.new(slug: slug_em(country_code)) if country.nil?
        # Always override the name and country code with value from geocode result.
        country.name = country_name
        country.code = country_code

        unless country.nil?
          country.latitude = country_result['geometry']['location']['lat']
          country.longitude = country_result['geometry']['location']['lng']
        end
      end

      # After all the reverse geocode, we still can't find country?
      if country.nil?
        return {
          country: nil,
          errors: ['Unable to resolve known country data.']
        }
      end

      # Geocode data doesn't return the 3 char country code. Use the UN lookup table.
      # See: https://unstats.un.org/unsd/methodology/m49/
      # See: https://www.iban.com/country-codes
      country_yml = lookup_country_by_code(country_lookup_data, country.code)
      unless country_yml.nil?
        country.code_longer = country_yml['country_code']
      end

      country.name = name
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
