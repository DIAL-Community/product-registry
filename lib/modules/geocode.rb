# frozen_string_literal: true

module Modules
  module Geocode
    def find_country(country_code_or_name, google_auth_key)
      return if country_code_or_name.blank?

      puts "Processing country: #{country_code_or_name}."
      country = Country.find_by('name = ? OR code = ? OR ? = ANY(aliases)',
                                country_code_or_name, country_code_or_name, country_code_or_name)
      if country.nil?
        country = Country.new
        country_data = JSON.parse(geocode_with_google(country_code_or_name, country_code_or_name, google_auth_key))

        country_results = country_data['results']
        country_results.each do |country_result|
          address_key = country_result['types'].reject { |x| x == 'political' }
                                               .first
          country_result['address_components'].each do |address_component|
            next unless address_component['types'].include?(address_key)

            country.name = address_component['long_name']
            country.code = address_component['short_name']
            country.slug = slug_em(country.code)
            country.code_longer = ''
          end
          country.latitude = country_result['geometry']['location']['lat']
          country.longitude = country_result['geometry']['location']['lng']
        end

        country.aliases << country_code_or_name
        if country.save!
          puts("Country saved: #{country.name}.")
        end
      end
      country
    end

    def find_region(region_name, country_code, google_auth_key)
      return if region_name.blank?

      puts "Processing region: #{region_name}."
      country = find_country(country_code, google_auth_key)
      region = Region.find_by('(name = ? OR ? = ANY(aliases)) AND country_id = ?',
                                    region_name, region_name, country.id)
      if region.nil?
        region = Region.new
        region.country_id = country.id

        address = "#{region_name}, #{country_code}"
        region_data = JSON.parse(geocode_with_google(address, country_code, google_auth_key))

        region_results = region_data['results']
        region_results.each do |region_result|
          address_key = region_result['types'].reject { |x| x == 'political' }
                                              .first
          region_result['address_components'].each do |address_component|
            next unless address_component['types'].include?(address_key)

            region.name = address_component['long_name']
            region.slug = slug_em(region.name)
          end
          region.latitude = region_result['geometry']['location']['lat']
          region.longitude = region_result['geometry']['location']['lng']
        end

        region.aliases << region_name
        if region.save!
          puts("Region saved: #{region.name}.")
        end
      end
      region
    end

    def find_city(city_name, region_name, country_code, google_auth_key)
      puts "Processing city: #{city_name}."

      # Need to do this because Ramallah doesn't have region or country.
      region = find_region(region_name, country_code, google_auth_key)
      if region.nil?
        city = City.find_by('(name = ? OR ? = ANY(aliases))', city_name, city_name)
      else
        city = City.find_by('(name = ? OR ? = ANY(aliases)) AND region_id = ?', city_name, city_name, region.id)
      end

      if city.nil?
        city = City.new

        unless region.nil?
          city.region_id = region.id
        end

        address = city_name
        unless region_name.blank?
          address = "#{address}, #{region_name}"
        end

        unless country_code.blank?
          address = "#{address}, #{country_code}"
        end

        city_data = JSON.parse(geocode_with_google(address, country_code, google_auth_key))

        city_results = city_data['results']
        city_results.each do |city_result|
          address_key = city_result['types'].reject { |x| x == 'political' }
                                            .first
          city_result['address_components'].each do |address_component|
            next unless address_component['types'].include?(address_key)

            city.name = address_component['long_name']
            city.slug = slug_em(address)
          end
          city.latitude = city_result['geometry']['location']['lat']
          city.longitude = city_result['geometry']['location']['lng']
        end

        city.aliases << city_name
        if city.save!
          puts("City saved: #{city.name}.")
        end
      end
      city
    end

    def geocode_with_google(address, country_code, auth_key)
      puts "Geocoding address: #{address} in region: #{country_code}."
      uri_template = Addressable::Template.new('https://maps.googleapis.com/maps/api/geocode/json{?q*}')
      geocode_uri = uri_template.expand({
        'q' => {
          'key' => auth_key,
          'address' => address,
          'region' => country_code
        }
      })

      uri = URI.parse(geocode_uri)
      Net::HTTP.get(uri)
    end

    def reverse_geocode_with_google(location, auth_key)
      puts "Reverse geocoding location: (#{location.points[0].x.to_f}, #{location.points[0].y.to_f})."
      uri_template = Addressable::Template.new('https://maps.googleapis.com/maps/api/geocode/json{?q*}')
      geocode_uri = uri_template.expand({
        'q' => {
          'key' => auth_key,
          'latlng' => "#{location.points[0].x.to_f}, #{location.points[0].y.to_f}"
        }
      })

      uri = URI.parse(geocode_uri)
      Net::HTTP.get(uri)
    end
  end
end
