require "fileutils"
require 'modules/projects'
require 'modules/geocode'

include Modules::Projects

namespace :projects do
  desc 'Read data from COVID projects spreadsheet (UNICEF)'
  task :sync_unicef_covid => :environment do |_, params|

    spreadsheet_id = "1Y6fl3Uqvn0lcFhBlYPXLKKi2HXi79kw8pWR_h8PwE3s"
    range = "1. Partners support to frontline HWs tools!A1:Z"
    response = sync_spreadsheet(spreadsheet_id, range)
    headers = response.values.shift
    # take off the first 2 - region and country
    headers.shift
    headers.shift
    puts "No data found." if response.values.empty?
    response.values.each do |row|
      region = row.shift
      country = row.shift
      row.each_with_index do |column, index| 
        if !column.nil? && !column.blank?
          #puts column + " implemented " + headers[index] + " in " + country
          create_project_entry(column, headers[index], country, "UNICEF Covid")  # org, product, country
        end
      end
    end
  end

  def geocode_city(city_name)
    city_data = {}
    google_auth_key = Rails.application.secrets.google_api_key

    city_location = nil
    geocode_data = JSON.parse(geocode_with_google(city_name, nil, google_auth_key))
    geocode_results = geocode_data['results']
    geocode_results.each do |geocode_result|
      next if geocode_result['types'].include?('point_of_interest')

      geometry = geocode_result['geometry']
      city_location = Location.new(
        points: [ActiveRecord::Point.new(geometry['location']['lat'], geometry['location']['lng'])]
      )
    end

    return if city_location.nil?

    geocode_data = JSON.parse(reverse_geocode_with_google(city_location, google_auth_key))
    geocode_results = geocode_data['results']
    geocode_results.each do |geocode_result|
      next if geocode_result['types'].include?('point_of_interest')

      geocode_result['address_components'].each do |address_component|
        if address_component['types'].include?('locality') ||
          address_component['types'].include?('postal_town')
          city_data['city'] = address_component['long_name']
        elsif address_component['types'].include?('administrative_area_level_1')
          city_data['region'] = address_component['long_name']
        elsif address_component['types'].include?('country')
          city_data['country_code'] = address_component['short_name']
        end
      end
    end

    unless city_data['city'].blank? || city_data['region'].blank? || city_data['country_code'].blank?
      find_city(city_data['city'], city_data['region'], city_data['country_code'], google_auth_key)
    end
  end

  desc 'Read data from New America Digital Government Platform Tracker'
  task :parse_digital_gov_tracker, [:digital_gov_tracker_file] => :environment do |_, params|
    dgpt_origin = Origin.find_by(name: 'Digital Government Platform Tracker')
    if dgpt_origin.nil?
      dgpt_origin = Origin.new
      dgpt_origin.name = 'Digital Government Platform Tracker'
      dgpt_origin.slug = slug_em(dgpt_origin.name)
      dgpt_origin.description = "The Digital Government Platform Tracker is a catalogue of "\
                                "digital government platforms that strengthen public institutions. "\
                                "The examples represent the work of different jurisdictions and "\
                                "organizations to build digital government platforms that improve "\
                                "public services for their constituents. "

      if dgpt_origin.save
        puts 'Digital government platform tracker as origin is created.'
      end
    end

    tracker_data = CSV.parse(File.read(params[:digital_gov_tracker_file]), headers: true,
                             liberal_parsing: { double_quote_outside_quote: true })
    tracker_data.each do |data|
      description_template = ""\
        "<div>"\
        "  <p>"\
        "    <div class='text-muted'>Jurisdiction of Origin</div>"\
        "    <div class='text-body'>{{_jurisdiction_of_origin_}}</div>"\
        "  </p>"\
        "  <p>"\
        "    <div class='text-muted'>Lead Organization</div>"\
        "    <div class='text-body'>{{_lead_organization_}}</div>"\
        "  </p>"\
        "  <p>"\
        "    <div class='text-muted'>Partners</div>"\
        "    <div class='text-body'>{{_partners_}}</div>"\
        "  </p>"\
        "  <p>"\
        "    <div class='text-muted'>Description</div>"\
        "    <div class='text-body'>{{_description_}}</div>"\
        "  </p>"\
        "</div>"

      project_name = data["Platform Name"]
      puts "-----***-----"
      puts "Processing: #{project_name}."

      existing_project = Project.find_by(name: project_name, origin_id: dgpt_origin.id)
      if existing_project.nil?
        existing_project = Project.new
        existing_project.name = project_name
        existing_project.slug = slug_em(existing_project.name)
        existing_project.origin = dgpt_origin
      end
      description_template = description_template.sub('{{_description_}}', data["Description"])

      jurisdictions = data["Jurisdiction of Origin"]
      description_template = description_template.sub('{{_jurisdiction_of_origin_}}', jurisdictions)

      country = nil
      project_countries = []
      if !jurisdictions.index(';').nil?
        jurisdiction_data = jurisdictions.split(';')
        jurisdiction_data.each do |jurisdiction|
          if jurisdictions.index(',').nil?
            country = Country.find_by(name: jurisdiction.strip)
            puts "Searching country: #{jurisdiction} resolving: #{country}."
          else
            city_country = jurisdictions.split(',')
            city = geocode_city(name: city_country[0])
            puts "Searching city: #{city_country[0]} resolving: #{city}."
            if city.nil?
              country = Country.find_by(name: city_country[1])
              puts "Searching country: #{city_country[1]} resolving: #{country}."
            else
              country = city.region.country
            end
          end
          project_countries << country unless country.nil?
        end
      elsif !jurisdictions.index(',').nil?
        # Multiple country? Or City, Country
        city_country = jurisdictions.split(',')
        city = geocode_city(name: city_country[0])
        puts "Searching city: #{city_country[0]} resolving: #{city}."
        if city.nil?
          country = Country.find_by(name: city_country[1])
          puts "Searching country: #{city_country[1]} resolving: #{country}."
        else
          country = city.region.country
        end
        project_countries << country unless country.nil?
      else
        # It's just a single country entry
        country = Country.find_by(name: jurisdictions.strip)
        puts "Searching country: #{jurisdictions} resolving: #{country}."
        if country.nil?
          # Or is it a city?
          city = geocode_city(name: jurisdictions.strip)
          country = city.region.country unless city.nil?
        end
        project_countries << country unless country.nil?
      end
      existing_project.countries = project_countries

      # Assign sector information based on the pillar data?
      sector = Sector.find_by(name: data["Pillar"].strip)
      unless sector.nil?
        existing_project.sectors << sector
      end

      # Set the project url
      existing_project.project_url = data['Link']

      # Assign products to the project based on the product's website
      products = Set.new
      # It could be in this column.
      data['Open Source + Repo'].gsub(/\s+/m, ' ')
                                .strip
                                .split(" ")
                                .each do |oss_website|
        # sanitized_website = oss_website.sub(/.*?(?=http)/im, '')
        product = Product.where('LOWER(products.website) like LOWER(?)', "%#{oss_website}%")
                         .first
        products << product unless product.nil?
        product = Product.where('LOWER(products.repository) like LOWER(?)', "%#{oss_website}%")
                         .first
        products << product unless product.nil?
      end
      # Or it could be in the link column
      data['Link'].gsub(/\s+/m, ' ')
                  .strip
                  .split(" ")
                  .each do |oss_website|
        product = Product.where('LOWER(products.website) like LOWER(?)', "%#{oss_website}%")
                         .first
        products << product unless product.nil?
        product = Product.where('LOWER(products.repository) like LOWER(?)', "%#{oss_website}%")
                         .first
        products << product unless product.nil?
      end
      existing_project.products = products.to_a

      if existing_project.save!
        puts "Project #{existing_project.name} saved!"
      end

      description_template = description_template.sub('{{_lead_organization_}}', data["Lead Organization"])
      data["Lead Organization"].split(',')
                               .each do |organization|
        owner_org = Organization.find_by(name: organization.strip)
        next if owner_org.nil?
        next if existing_project.organizations.include?(owner_org)

        project_owner = ProjectsOrganization.new
        project_owner.org_type = 'owner'
        project_owner.project_id = existing_project.id
        project_owner.organization_id = owner_org.id
        if project_owner.save!
          puts "Owning organization saved!"
        end
      end

      description_template = description_template.sub('{{_partners_}}', data["Partners"])
      data["Partners"].split(',')
                      .each do |partner|
        partner_org = Organization.find_by(name: partner.strip)
        next if partner_org.nil?
        next if existing_project.organizations.include?(partner_org)

        project_partner = ProjectsOrganization.new
        project_partner.org_type = 'implementer'
        project_partner.project_id = existing_project.id
        project_partner.organization_id = partner_org.id
        if project_partner.save!
          puts "Partner organization saved!"
        end
      end

      project_description = ProjectDescription.find_by(project_id: existing_project.id, locale: I18n.locale)
      if project_description.nil?
        project_description = ProjectDescription.new
        project_description.project = existing_project
        project_description.locale = I18n.locale
      end

      project_description.description = description_template
      if project_description.save!
        puts "Project description updated!"
      end
    end
  end

  desc 'Read data from WHO categorization spreadsheet (Digital Square)'
  task :sync_who_categories => :environment do |_, params|

    spreadsheet_id = "1OFGTQsjtEuSU2biJtc1ps53Dbh9AaRMBr_SzVuOPxGw"
    range = "Mapping!B2:AD66"
    response = sync_spreadsheet(spreadsheet_id, range)
    headers = response.values.shift
    # take off the first column - empty
    headers.shift

    # First create all of the category data from the headers
    headers.each do |header|
      indicator = header.slice(0,3)
      desc = header[4..-1]
      if Classification.find_by(indicator: indicator).nil?
        puts "CREATING CLASSIFICATION"
        classification = Classification.new
        classification.indicator = indicator
        classification.name = desc
        classification.description = desc
        classification.source = "Digital Health Atlas"
        classification.save
      end
    end

    puts "No data found." if response.values.empty?
    response.values.each do |row|
      product = row.shift
      if !product.nil?
        prod_search = product.strip.downcase
        curr_product = Product.find_by("LOWER(name) LIKE ?", prod_search)
        if curr_product.nil?
          curr_product = Product.find_by("LOWER(name) LIKE ? OR ? = ANY(LOWER(aliases::text)::text[])", "%"+prod_search+"%", prod_search)
        end
        if !curr_product.nil?
          row.each_with_index do |column, index| 
            if !column.nil? && !column.blank?
              indicator = headers[index].slice(0,3)
              classification = Classification.find_by(indicator: indicator)
              if !classification.nil?
                puts product.to_s + " mapped to " + headers[index].to_s
                curr_class = ProductClassification.find_by("product_id=? AND classification_id=?", curr_product, classification)
                if curr_class.nil?
                  prod_class = ProductClassification.new
                  prod_class.product_id = curr_product.id
                  prod_class.classification_id = classification.id
                  prod_class.save
                end
              end
            end
          end
        else
          puts "COULD NOT FIND PRODUCT: "+product.to_s
        end
      end
    end
  end
end
