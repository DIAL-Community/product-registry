# frozen_string_literal: true

require 'modules/slugger'

namespace :geocode do
  desc 'Geocode to find lattitude and longitude of addresses.'

  task :regions, [:path_to_regions_file, :country_code] => :environment do |_, params|
    params.with_defaults(country_code: 'USA')
    country = Country.find_by(code: params[:country_code])

    puts("Reading regions from: #{params[:path_to_regions_file]}")
    region_string = File.read(params[:path_to_regions_file])
    addresses = build_regions(region_string, country)

    puts("Geocoding: #{addresses[:records].length} regions!")
    auth_token = authenticate_user
    response = geocode(addresses, params[:country_code], auth_token)

    region_data = JSON.parse(response.body)

    region_data['locations'].each do |region|
      region_record = Region.new
      region_record.name = region['attributes']['Region']
      region_record.slug = slug_em(region_record.name)
      region_record.country_id = country.id
      region_record.latitude = region['location']['x']
      region_record.longitude = region['location']['y']

      if region_record.save!
        puts("Saving region: #{region_record.name}.")
      end
    end
  end

  task :districts, [:path_to_districts_file, :country_code] => :environment do |_, params|
    params.with_defaults(country_code: 'USA')
    country = Country.find_by(code: params[:country_code])

    puts("Reading districts from: #{params[:path_to_districts_file]}")
    district_string = File.read(params[:path_to_districts_file])
    addresses = build_districts(district_string, country)

    puts("Geocoding: #{addresses[:records].length} districts!")
    auth_token = authenticate_user
    response = geocode(addresses, params[:country_code], auth_token)

    region_data = JSON.parse(response.body)

    region_data['locations'].each do |region|
      region_record = District.new
      region_record.name = region['attributes']['Subregion']
      region_record.slug = slug_em(region_record.name)
      region_record.country_id = country.id
      region_record.latitude = region['location']['x']
      region_record.longitude = region['location']['y']

      if region_record.save!
        puts("Saving region: #{region_record.name}.")
      end
    end
  end

  task :load_countries, [:path_to_countries_file, :path_to_iban_file] => :environment do |_, params|
    countries = CSV.parse(File.read(params[:path_to_countries_file]), headers: true)
    countries.each do |country|
      country_record = Country.new
      country_record.name = country[3].strip
      country_record.code = country[0].strip
      # Hack to prevent error on initial load
      country_record.code_longer = ''
      country_record.slug = slug_em(country_record.code)

      country_record.latitude = country[1].to_f
      country_record.longitude = country[2].to_f

      if country_record.save!
        puts("Saving country: #{country_record.name}.")
      end
    end

    countries_iban = CSV.parse(File.read(params[:path_to_iban_file]), headers: true, col_sep: "\t")
    countries_iban.each do |country_iban|
      country_record = Country.find_by(code: country_iban[1].strip)
      if country_record.nil?
        puts "Skipping nil country for: #{country_iban[1].strip}."
        next
      end

      country_record.code_longer = country_iban[2].strip
      country_record.aliases << country_record.name
      country_record.name = country_iban[0]

      if country_record.save!
        puts("Saving 3 letters country code for: #{country_record.name}.")
      end
    end
  end

  task :migrate_projects_locations_with_google, [] => :environment do
    google_auth_key = Rails.application.secrets.google_api_key
    Project.all.each do |project|
      puts "Processing #{project.name} ..."
      project.projects_locations.each do |project_location|
        if project_location.migrated
          puts "Location already migrated. Skipping!"
          next
        end

        # Location is a country, change the reference to countries table.
        location = Location.find_by(id: project_location.location_id)
        if location.nil? || location.location_type != 'country'
          puts "Skipping unresolved country: #{location.name}."
          next
        end

        country = find_country(location.name, google_auth_key)
        if country.nil?
          puts "Skipping country without geocoded data: #{location.name}."
          next
        end

        countries = project.countries.where(id: country.id)
        if countries.empty?
          project.countries.push(country)
        end
        project_location.migrated = true
        project_location.migrated_date = Time.now
        if project_location.save!
          puts "Location marked as migrated: #{project_location.location_id}."
        end
      end
    end
  end

  task :migrate_organizations_locations_with_google, [] => :environment do
    google_auth_key = Rails.application.secrets.google_api_key
    Organization.all.each do |organization|
      puts "Processing #{organization.name} ..."
      organization.organizations_locations.each do |organization_location|
        if organization_location.migrated
          puts "Location already migrated. Skipping!"
          next
        end

        # Location is a country, change the reference to countries table.
        location = Location.find_by(id: organization_location.location_id)
        if location.location_type == 'country'
          country = find_country(location.name, google_auth_key)
          unless country.nil?
            countries = organization.countries.where(id: country.id)
            if countries.empty?
              organization.countries.push(country)
            end
            organization_location.migrated = true
            organization_location.migrated_date = Time.now
            if organization_location.save!
              puts "Location marked as migrated: #{organization_location.location_id}."
            end
          end
          next
        end

        # Location is a point:
        # * Reverse geocode to normalize the point
        # * Update using reverse geocode values
        # * Update reference to the state & countries

        office_data = {}

        geocode_data = JSON.parse(reverse_geocode_with_google(location, google_auth_key))
        geocode_results = geocode_data['results']
        geocode_results.each do |geocode_result|
          geocode_result['address_components'].each do |address_component|
            if address_component['types'].include?('locality') ||
              address_component['types'].include?('postal_town')
              office_data['city'] = address_component['long_name']
            elsif address_component['types'].include?('administrative_area_level_2')
              office_data['subregion'] = address_component['long_name']
            elsif address_component['types'].include?('administrative_area_level_1')
              office_data['region'] = address_component['long_name']
            elsif address_component['types'].include?('country')
              office_data['country_code'] = address_component['short_name']
            end
          end
        end

        office = Office.new
        office.organization_id = organization.id

        country_code = office_data['country_code']
        unless office_data['country_code'].blank?
          country = find_country(country_code, google_auth_key)
          office.country_id = country.id
        end

        region_name = office_data['region']
        unless office_data['region'].blank? || office_data['country_code'].blank?
          region = find_region(region_name, country_code, google_auth_key)
          office.region_id = region.id
        end

        city_name = office_data['city']
        unless office_data['city'].blank? || office_data['region'].blank? || office_data['country_code'].blank?
          city = find_city(city_name, region_name, country_code, google_auth_key)

          office.city = city.name

          office.latitude = city.latitude
          office.longitude = city.longitude
        end

        if office_data['city'].blank? || office_data['region'].blank? || office_data['country_code'].blank?
          office.latitude = location[:points][0].x
          office.longitude = location[:points][0].y
          office.city = office_data['city'].blank? ? "Unknown" : office_data['city']
        end

        address = "#{city_name}, #{region_name}, #{country_code}"
        office.name = address
        office.slug = slug_em("#{organization.name} #{office.name}")

        if Office.find_by(slug: office.slug).nil?
          if office.save!
            puts "Saving office data for: #{office.name} -> #{office.slug}."
            organization_location.migrated = true
            organization_location.migrated_date = Time.now
            if organization_location.save!
              puts "Location marked as migrated: #{organization_location.location_id}."
            end
          end
        else
          puts "Office already in database: #{office.slug}."
          organization_location.migrated = true
          organization_location.migrated_date = Time.now
          if organization_location.save!
            puts "Location marked as migrated: #{organization_location.location_id}."
          end
        end
      end
      puts "------------------------------------------"
    end
  end

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

  task :migrate_locations, [] => :environment do
    auth_token = authenticate_user
    Organization.all.each do |organization|
      puts "Processing #{organization.name} ..."
      organization.locations.each do |location|
        if location.location_type == 'country'
          country = Country.find_by(name: location.name)
          unless country.nil?
            organization.countries.push(country)
          end
          next
        end

        # Location is a point
        office = Office.new
        office.name = location.name
        office.slug = slug_em("#{organization.name} #{office.name}")
        office.city = location.city

        region_name = location.state
        org_country = Country.find_by('name = ? OR ? = ANY(aliases)', location.country, location.country)

        if region_name.nil? || region_name.blank?
          response = reverse_geocode(location, auth_token)
          location_data = JSON.parse(response.body)

          office.city = location_data['address']['ShortLabel']
          region_name = location_data['address']['Region']
          country_code = location_data['address']['CountryCode']

          if region_name.nil? || region_name.blank?
            region_element = {}
            region_element['ObjectId'] = 1
            region_element['SingleLine'] = office.city
            region_list = [{ 'attributes': region_element }]

            response = geocode({ 'records': region_list }, country_code, auth_token)
            region_data = JSON.parse(response.body)
            region_data['locations'].each do |region|
              next if region['address'].blank? || region['address'].nil?

              office.city = region['attributes']['City']
              region_name = region['attributes']['Region']
              country_code = region['attributes']['Country']
            end
          end

          if org_country.nil?
            org_country = Country.find_by(code_longer: country_code)
          end
          puts "Reverse geocoding returned: #{office.city}, #{region_name}, #{org_country.code_longer}!"
        end

        unless org_country.nil?
          puts "Found country for: #{location.country} -> #{org_country.code_longer}."
          office.country_id = org_country.id
        end

        org_region = Region.find_by('name = ? OR ? = ANY(aliases)', region_name, region_name)
        if org_region.nil?
          puts "Geocoding to find: #{region_name} in country #{org_country.code}."
          addresses = build_regions(region_name, org_country)

          country_code = nil
          unless org_country.nil?
            country_code = org_country.code_longer
          end

          response = geocode(addresses, country_code, auth_token)
          region_data = JSON.parse(response.body)
          region_data['locations'].each do |region|
            if region['address'].blank? || region['address'].nil?
              puts "Skipping unresolved region: #{region_name}!"
              next
            end

            region_record = Region.new
            region_record.name = region['attributes']['Region']
            region_record.slug = slug_em(region_record.name)
            region_record.country_id = org_country.id
            region_record.latitude = region['location']['x']
            region_record.longitude = region['location']['y']
            region_record.aliases << region_name

            if region_record.save!
              office.region_id = region_record.id
              puts("Saving region: #{region_record.name}.")
            end
          end
        else
          office.region_id = org_region.id
        end

        office.latitude = location.points[0].x.to_f
        office.longitude = location.points[0].y.to_f

        office.organization = organization

        if office.save!
          puts "Office for #{organization.name} -> #{office.name} saved!"
        end
      end

      # Done processing the organization. Save it.
      if organization.save!
        puts "Saving: #{organization.name}!"
      end
    end
  end

  def build_regions(region_string, country)
    region_list = []
    region_string.split("\n").each_with_index do |region, index|
      if region.blank?
        puts('Skipping blank region!')
        next
      end

      unless country.nil?
        existing_regions = Region.where('(slug = ? OR ? = ANY(aliases)) AND country_id = ?',
                                        slug_em(region), region, country.id)
        unless existing_regions.empty?
          puts("Skipping existing record for #{region} in #{country.code}!")
          next
        end
      end

      puts("Processing: #{region}")

      region_element = {}
      region_element['objectId'] = index + 1
      region_element['region'] = region
      region_list << { 'attributes': region_element }
    end
    { 'records': region_list }
  end

  def authenticate_user
    uri = URI.parse(Rails.configuration.geocode['esri']['auth_uri'])
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path)

    data = { 'client_id' => Rails.configuration.geocode['esri']['client_id'],
             'client_secret' => Rails.configuration.geocode['esri']['client_secret'],
             'grant_type' => Rails.configuration.geocode['esri']['grant_type'] }
    request.set_form_data(data)

    response = http.request(request)
    response_json = JSON.parse(response.body)
    response_json['access_token']
  end

  def reverse_geocode(location, auth_token)
    uri = URI.parse(Rails.configuration.geocode['esri']['reverse_geocode_uri'])
    post_data = {
      'location': "#{location.points[0].y}, #{location.points[0].x}",
      'token': auth_token,
      'f': 'json'
    }

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path, { 'Content-Type': 'multipart/form-data' })
    request.set_form_data(post_data)

    http.request(request)
  end

  def geocode(addresses, country_code, auth_token)
    uri = URI.parse(Rails.configuration.geocode['esri']['convert_uri'])
    post_data = {
      'addresses': addresses.to_json,
      'token': auth_token,
      'f': 'json'
    }

    unless country_code.nil?
      post_data['sourceCountry'] = country_code
    end

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path, { 'Content-Type': 'multipart/form-data' })
    request.set_form_data(post_data)

    http.request(request)
  end
end
