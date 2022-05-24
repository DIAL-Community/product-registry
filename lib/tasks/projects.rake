# frozen_string_literal: true
# rubocop:disable Metrics/BlockNesting

# TODO: Revisit this module to reduce the if nesting.
# Disabling because of this rubocop issue:
# - Avoid more than 3 levels of block nesting. (convention:Metrics/BlockNesting)

require 'fileutils'
require 'modules/projects'
require 'modules/geocode'
require 'google/cloud/translate/v2'

include Modules::Projects

namespace :projects do
  desc 'Read data from COVID projects spreadsheet (UNICEF)'
  task sync_unicef_covid: :environment do |_, _params|
    spreadsheet_id = '1Y6fl3Uqvn0lcFhBlYPXLKKi2HXi79kw8pWR_h8PwE3s'
    range = '1. Partners support to frontline HWs tools!A1:Z'
    response = sync_spreadsheet(spreadsheet_id, range)
    headers = response.values.shift
    # take off the first 2 - region and country
    headers.shift
    headers.shift
    puts 'No data found.' if response.values.empty?
    response.each_value do |row|
      row.shift
      country = row.shift
      row.each_with_index do |column, index|
        if !column.nil? && !column.blank?
          # puts column + " implemented " + headers[index] + " in " + country
          create_project_entry(column, headers[index], country, 'UNICEF Covid') # org, product, country
        end
      end
    end
  end

  def geocode_city(city_name)
    city_data = {}
    google_auth_key = Rails.application.secrets.google_api_key

    geocode_data = JSON.parse(geocode_with_google(city_name, nil, google_auth_key))
    geocode_results = geocode_data['results']
    geocode_results.each do |geocode_result|
      puts 'Geocode: ' + geocode_result.to_s
      next if geocode_result['types'].include?('point_of_interest')

      geometry = geocode_result['geometry']
      points = [ActiveRecord::Point.new(geometry['location']['lat'], geometry['location']['lng'])]

      geopoint_data = JSON.parse(reverse_geocode_with_google(points, google_auth_key))
      geopoint_results = geopoint_data['results']
      geopoint_results.each do |geopoint_result|
        next if geopoint_result['types'].include?('point_of_interest')

        geopoint_result['address_components'].each do |address_component|
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
  end

  desc 'Read data from New America Digital Government Platform Tracker'
  task :parse_digital_gov_tracker, [:digital_gov_tracker_file] => :environment do |_, params|
    dgpt_origin = Origin.find_by(name: 'Digital Government Platform Tracker')
    if dgpt_origin.nil?
      dgpt_origin = Origin.new
      dgpt_origin.name = 'Digital Government Platform Tracker'
      dgpt_origin.slug = slug_em(dgpt_origin.name)
      dgpt_origin.description = 'The Digital Government Platform Tracker is a catalogue of '\
                                'digital government platforms that strengthen public institutions. '\
                                'The examples represent the work of different jurisdictions and '\
                                'organizations to build digital government platforms that improve '\
                                'public services for their constituents. '

      puts 'Digital government platform tracker as origin is created.' if dgpt_origin.save
    end

    tracker_data = CSV.parse(File.read(params[:digital_gov_tracker_file]),
                             headers: true,
                             liberal_parsing: { double_quote_outside_quote: true })
    tracker_data.each do |data|
      description_template = ''\
        '<div>'\
        '  <p>'\
        "    <div class='text-muted'>Jurisdiction of Origin</div>"\
        "    <div class='text-body'>{{_jurisdiction_of_origin_}}</div>"\
        '  </p>'\
        '  <p>'\
        "    <div class='text-muted'>Lead Organization</div>"\
        "    <div class='text-body'>{{_lead_organization_}}</div>"\
        '  </p>'\
        '  <p>'\
        "    <div class='text-muted'>Partners</div>"\
        "    <div class='text-body'>{{_partners_}}</div>"\
        '  </p>'\
        '  <p>'\
        "    <div class='text-muted'>Description</div>"\
        "    <div class='text-body'>{{_description_}}</div>"\
        '  </p>'\
        '</div>'

      project_name = data['Platform Name']
      puts '-----***-----'
      puts "Processing: #{project_name}."

      existing_project = Project.find_by(name: project_name, origin_id: dgpt_origin.id)
      if existing_project.nil?
        existing_project = Project.new
        existing_project.name = project_name
        existing_project.slug = slug_em(existing_project.name)
        existing_project.origin = dgpt_origin
      end
      description_template = description_template.sub('{{_description_}}', data['Description'])

      jurisdictions = data['Jurisdiction of Origin']
      description_template = description_template.sub('{{_jurisdiction_of_origin_}}', jurisdictions)

      country = nil
      project_countries = []
      if jurisdictions != 'N/A' && jurisdictions != 'Unknown'
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
              elsif !city.is_a?(Array)
                country = city.region.country
              end
            end
            project_countries << country unless country.nil?
          end
        elsif !jurisdictions.index(',').nil?
          # Multiple country? Or City, Country
          city_country = jurisdictions.split(',')
          city = geocode_city(name: city_country[0])
          puts "Searching city: #{city_country[0]} resolving: #{city[0]}."
          if city[0].nil?
            country = Country.find_by(name: city_country[1])
            puts "Searching country: #{city_country[1]} resolving: #{country}."
          else
            country = city[0]['region']['country'] unless city[0]['region'].nil?
          end
          project_countries << country unless country.nil?
        else
          # It's just a single country entry
          country = Country.find_by(name: jurisdictions.strip)
          puts "Searching country: #{jurisdictions} resolving: #{country}."
          if country.nil?
            # Or is it a city?
            city = geocode_city(name: jurisdictions.strip)
            if !city.is_a?(Array) && !city.nil?
              country = city.region.country
            end
          end
          project_countries << country unless country.nil?
        end
        existing_project.countries = project_countries
      end

      # Assign sector information based on the pillar data?
      sector = Sector.find_by(name: data['Pillar'].strip)
      existing_project.sectors << sector unless sector.nil?

      # Set the project url
      existing_project.project_url = data['Link']

      # Assign products to the project based on the product's website
      products = Set.new
      # It could be in this column.
      data['Open Source + Repo'].gsub(/\s+/m, ' ')
                                .strip
                                .split(' ')
                                .each do |oss_website|
        next if ['N/A', 'No'].include?(oss_website)

        puts 'OSS Website: ' + oss_website
        # sanitized_website = oss_website.sub(/.*?(?=http)/im, '')
        product = Product.where('LOWER(products.website) like LOWER(?)', "%#{oss_website}%")
                         .first
        puts 'Product found by website: ' + product.name unless product.nil?
        products << product unless product.nil?
        repository = ProductRepository.where('LOWER(absolute_url) like LOWER(?)', "%#{oss_website}%").first
        next if repository.nil?

        product = Product.find(repository['product_id'])
        puts 'Product found by repository: ' + product.name unless product.nil?
        products << product unless product.nil?
      end
      # Or it could be in the link column
      data['Link'].gsub(/\s+/m, ' ')
                  .strip
                  .split(' ')
                  .each do |oss_website|
        puts 'Link OSS Website: ' + oss_website
        product = Product.where('LOWER(products.website) like LOWER(?)', "%#{oss_website}%")
                         .first
        puts 'Product found by website: ' + product.name unless product.nil?
        products << product unless product.nil?
        repository = ProductRepository.where('LOWER(absolute_url) like LOWER(?)', "%#{oss_website}%").first
        puts 'Repository found: ' + repository.name unless repository.nil?
        next if repository.nil?

        product = Product.find(repository.product_id)
        puts 'Product found by repository: ' + product.name unless product.nil?
        products << product unless product.nil?
      end
      existing_project.products = products.to_a

      puts "Project #{existing_project.name} saved!" if existing_project.save!

      description_template = description_template.sub('{{_lead_organization_}}', data['Lead Organization'])
      data['Lead Organization'].split(',')
                               .each do |organization|
        owner_org = Organization.find_by(name: organization.strip)
        next if owner_org.nil?
        next if existing_project.organizations.include?(owner_org)

        project_owner = ProjectsOrganization.new
        project_owner.org_type = 'owner'
        project_owner.project_id = existing_project.id
        project_owner.organization_id = owner_org.id
        puts 'Owning organization saved!' if project_owner.save!
      end

      description_template = description_template.sub('{{_partners_}}', data['Partners'])
      data['Partners'].split(',')
                      .each do |partner|
        partner_org = Organization.find_by(name: partner.strip)
        next if partner_org.nil?
        next if existing_project.organizations.include?(partner_org)

        project_partner = ProjectsOrganization.new
        project_partner.org_type = 'implementer'
        project_partner.project_id = existing_project.id
        project_partner.organization_id = partner_org.id
        puts 'Partner organization saved!' if project_partner.save!
      end

      project_description = ProjectDescription.find_by(project_id: existing_project.id, locale: I18n.locale)
      if project_description.nil?
        project_description = ProjectDescription.new
        project_description.project = existing_project
        project_description.locale = I18n.locale
      end

      project_description.description = description_template
      puts 'Project description updated!' if project_description.save!
    end
  end

  desc 'Read Digital Square Map & Match data'
  task :import_map_match, [:map_match_file] => :environment do |_, params|
    dsq_origin = Origin.find_by(name: 'Digital Square')
    sector_list = Sector.where("slug = 'health' and is_displayable is true")

    mm_data = CSV.parse(File.read(params[:map_match_file]), headers: true,
                                                            liberal_parsing: { double_quote_outside_quote: true })
    missing_product_list = []
    mm_data.each do |mm_proj|
      next if mm_proj['software'].nil?

      product_list = mm_proj['software'].split(',')
      prod_list = []
      product_list.each do |prod|
        product = Product.first_duplicate(prod.split('(')[0].strip, nil)
        if !product.nil?
          prod_list << product
        else
          missing_product_list << prod.split('(')[0].strip
        end
      end
      next if prod_list.empty?

      proj_name = "#{mm_proj['country']} #{mm_proj['tool']}"
      curr_proj = Project.find_by(name: proj_name)
      if curr_proj.nil?
        curr_proj = Project.new
        curr_proj.origin = dsq_origin
        curr_proj.name = proj_name
        curr_proj.slug = slug_em(proj_name)
      else
        puts "Project exists: #{proj_name}"
        puts "New Description: #{mm_proj['tool_description']}"
      end
      curr_proj.tags = ['COVID-19']

      # TODO: Look at dha_broad and add this to sectors?? Create a map?
      curr_proj.sectors = sector_list
      curr_proj.products = prod_list.uniq

      country = Country.find_by(name: mm_proj['country'])
      unless country.nil?
        existing_country = ProjectsCountry.find_by(project: curr_proj, country: country)
        curr_proj.countries << country if existing_country.nil?
      end
      curr_proj.save
      mm_proj['funder']&.split(',')&.each do |funder|
        funder_org = Organization.first_duplicate(funder.strip, slug_em(funder.strip))
        if funder_org.nil?
          puts "Can't find Org: #{funder}"
        else
          existing_org = ProjectsOrganization.find_by(project: curr_proj, organization: funder_org)
          if existing_org.nil?
            proj_org = ProjectsOrganization.new
            proj_org.project = curr_proj
            proj_org.organization = funder_org
            proj_org.org_type = 'funder'
            proj_org.save
          end
        end
      end
      mm_proj['implementer']&.split(',')&.each do |implementer|
        impl_org = Organization.first_duplicate(implementer.strip, slug_em(implementer.strip))
        next if impl_org.nil?

        existing_org = ProjectsOrganization.find_by(project: curr_proj, organization: impl_org)
        next unless existing_org.nil?

        proj_org = ProjectsOrganization.new
        proj_org.project = curr_proj
        proj_org.organization = impl_org
        proj_org.org_type = 'implementer'
        proj_org.save
      end
      %w[en de fr].each do |locale|
        project_desc = ProjectDescription.find_by(project: curr_proj, locale: locale)
        project_desc = ProjectDescription.new if project_desc.nil?
        project_desc.project = curr_proj
        project_desc.locale = locale

        if !mm_proj['tool_description'].nil?
          project_desc.description = mm_proj['tool_description']
          # Put the contact information in the description as well
          unless mm_proj['dha_contact_ph1'].nil?
            project_desc.description += "<br /><strong>Contact Information</strong><p>#{mm_proj['dha_contact_ph1']}</p>"
          end
          unless mm_proj['dha_contact_email'].nil?
            project_desc.description += '<br /><strong>Contact Information</strong><p>'
            !mm_proj['dha_contact_firstname'].nil? && project_desc.description += mm_proj['dha_contact_firstname']
            !mm_proj['dha_contact_surname'].nil? && project_desc.description += mm_proj['dha_contact_surname']
            project_desc.description += '<br />'
            !mm_proj['dha_contact_org'].nil? && project_desc.description += mm_proj['dha_contact_org']
            project_desc.description += '<br />'
            !mm_proj['dha_contact_email'].nil? && project_desc.description += mm_proj['dha_contact_email']
            project_desc.description += '</p>'
          end

          # Link to the use case steps in the description
          unless mm_proj['covid_use_cases'].nil?
            project_desc.description += "<br /><strong>Use Cases: </strong><p>#{mm_proj['covid_use_cases']}</p>"
          end
        else
          project_desc.description = 'No project description'
        end
        project_desc.save
      end
    end
    puts "Missing products: #{missing_product_list.uniq.inspect}"
  end

  desc 'Read data from WHO categorization spreadsheet (Digital Square)'
  task sync_who_categories: :environment do |_, _params|
    spreadsheet_id = '1OFGTQsjtEuSU2biJtc1ps53Dbh9AaRMBr_SzVuOPxGw'
    range = 'Mapping!B2:AD66'
    response = sync_spreadsheet(spreadsheet_id, range)
    headers = response.values.shift
    # take off the first column - empty
    headers.shift

    # First create all of the category data from the headers
    headers.each do |header|
      indicator = header.slice(0, 3)
      desc = header[4..-1]
      next unless Classification.find_by(indicator: indicator).nil?

      puts 'Creating Classification.'
      classification = Classification.new
      classification.indicator = indicator
      classification.name = desc
      classification.description = desc
      classification.source = 'Digital Health Atlas'
      classification.save
    end

    puts 'No data found.' if response.values.empty?
    response.each_value do |row|
      product = row.shift
      next if product.nil?

      prod_search = product.strip.downcase
      curr_product = Product.find_by('LOWER(name) LIKE ?', prod_search)
      if curr_product.nil?
        curr_product = Product.find_by('LOWER(name) LIKE ? OR ? = ANY(LOWER(aliases::text)::text[])',
                                       "%#{prod_search}%", prod_search)
      end
      if !curr_product.nil?
        row.each_with_index do |column, index|
          next unless !column.nil? && !column.blank?

          indicator = headers[index].slice(0, 3)
          classification = Classification.find_by(indicator: indicator)
          next if classification.nil?

          puts "#{product} mapped to #{headers[index]}"
          curr_class = ProductClassification.find_by('product_id=? AND classification_id=?', curr_product,
                                                     classification)
          next unless curr_class.nil?

          prod_class = ProductClassification.new
          prod_class.product_id = curr_product.id
          prod_class.classification_id = classification.id
          prod_class.save
        end
      else
        puts "Could not find product: #{product}."
      end
    end
  end

  desc 'Use Google Cloud to update project translations'
  task translate_projects: :environment do |_, _params|
    translate = Google::Cloud::Translate::V2.new(project_id: 'molten-plate-329021',
                                                 credentials: './utils/translate-key-file.json')

    projects = Project.all
    projects.each do |project|
      project_desc = ProjectDescription.where(project_id: project, locale: 'en').first
      next if project_desc.nil?

      language = translate.detect(project_desc.description)
      case language.results[0].language
      when 'en'
        puts 'Project desc is English'
        german_desc = ProjectDescription.where(project_id: project, locale: 'de').first || ProjectDescription.new
        german_desc.locale = 'de'
        german_desc.project_id = project.id
        de_translation = translate.translate(project_desc.description, to: 'de')
        german_desc.description = de_translation
        german_desc.save

        french_desc = ProjectDescription.where(project_id: project, locale: 'fr').first || ProjectDescription.new
        french_desc.locale = 'fr'
        french_desc.project_id = project.id
        fr_translation = translate.translate(project_desc.description, to: 'fr')
        french_desc.description = fr_translation
        french_desc.save
      when 'de'
        puts 'Project desc is German'
        english_desc = ProjectDescription.where(project_id: project, locale: 'en').first || ProjectDescription.new
        english_desc.locale = 'en'
        english_desc.project_id = project.id
        en_translation = translate.translate(project_desc.description, to: 'en')
        english_desc.description = en_translation
        english_desc.save

        french_desc = ProjectDescription.where(project_id: project, locale: 'fr').first || ProjectDescription.new
        french_desc.locale = 'fr'
        french_desc.project_id = project.id
        fr_translation = translate.translate(project_desc.description, to: 'fr')
        french_desc.description = fr_translation
        french_desc.save
      end

      puts "Updated project: #{project.name}"
    end
  end

  task translate_proj_prod_org: :environment do |_, _params|
    translate = Google::Cloud::Translate::V2.new(project_id: 'molten-plate-329021',
                                                 credentials: './utils/translate-key-file.json')

    projects = Project.all
    projects.each do |project|
      puts "Translating #{project.name}"
      project_desc = ProjectDescription.where(project_id: project, locale: 'en').first
      next if project_desc.nil?

      %w[es pt sw].each do |locale|
        new_desc = ProjectDescription.where(project_id: project, locale: locale).first || ProjectDescription.new
        new_desc.locale = locale
        new_desc.project_id = project.id
        new_translation = translate.translate(project_desc.description, to: locale)
        new_desc.description = new_translation
        new_desc.save
      end
    end

    products = Product.all
    products.each do |product|
      puts "Translating #{product.name}"
      product_desc = ProductDescription.where(product_id: product, locale: 'en').first
      next if product_desc.nil?

      %w[es pt sw].each do |locale|
        new_desc = ProductDescription.where(product_id: product, locale: locale).first || ProductDescription.new
        new_desc.locale = locale
        new_desc.product_id = product.id
        new_translation = translate.translate(product_desc.description, to: locale)
        new_desc.description = new_translation
        new_desc.save
      end
    end

    orgs = Organization.all
    orgs.each do |org|
      puts "Translating #{org.name}"
      org_desc = OrganizationDescription.where(organization_id: org, locale: 'en').first
      next if org_desc.nil?

      %w[es pt sw].each do |locale|
        new_desc = OrganizationDescription.where(organization_id: org,
                                                 locale: locale).first || OrganizationDescription.new
        new_desc.locale = locale
        new_desc.organization_id = org.id
        new_translation = translate.translate(org_desc.description, to: locale)
        new_desc.description = new_translation
        new_desc.save
      end
    end
  end

  task update_project_slugs: :environment do |_, _params|
    Project.all.each do |project|
      slug_match = Project.where(slug: project.slug)
      next unless slug_match.count > 1
      slug_match.each_with_index do |slug_project, index|
        next if slug_project.id == project.id

        if !project.project_url.nil? && project.project_url == slug_project.project_url
          puts "DELETING duplicate: " + slug_project.name
          proj_descriptions = ProjectDescription.where(project_id: slug_project.id)
          proj_descriptions.each(&:destroy!)
          slug_project.destroy!
        else
          slug_project.slug = slug_em(slug_project.name, 64)
          if slug_project.slug == project.slug
            slug_project.slug = project.slug + "_dup" + index.to_s
          end
          puts "UPDATING slug to: " + slug_project.slug
          slug_project.save!
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockNesting
