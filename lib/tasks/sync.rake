# frozen_string_literal: true

require 'modules/slugger'
require 'modules/sync'
require 'faraday'

include Modules::Slugger
include Modules::Sync

namespace :sync do
  desc 'Sync uploaded images with local environment.'
  task :uploaded_images, [:path] => :environment do |_, _|
    directories = %w[organizations products]
    directories.each do |directory|
      cmd = " rsync -avP root@134.209.41.212:/root/product-registry/public/assets/#{directory}/ " \
            " public/assets/#{directory}/ "
      Open3.popen3(cmd) do |_stdin, stdout, stderr, wait_thr|
        while (line = stderr.gets)
          puts "stderr: #{line}"
        end
        while (line = stdout.gets)
          puts "stdout: #{line}"
        end
        exit_status = wait_thr.value
        abort("Sync failed for #{cmd}.") unless exit_status.success?
        puts "#{directory.titlecase} synced."
      end
    end
  end

  desc 'Sync the database with the public goods lists.'
  task :public_goods, [:path] => :environment do
    puts 'Pulling data from digital public goods repository ...'
    ignore_list = YAML.load_file('config/product_ignorelist.yml')

    dpg_uri = URI.parse('https://api.digitalpublicgoods.net/dpgs/')
    dpg_response = Net::HTTP.get(dpg_uri)
    dpg_data = JSON.parse(dpg_response)
    dpg_data.each do |entry|
      next if search_in_ignorelist(entry, ignore_list)

      prod = sync_public_product(entry)
      update_repository_data(entry, prod)
    end

    dpg_uri = URI.parse('https://api.digitalpublicgoods.net/nominees/')
    dpg_response = Net::HTTP.get(dpg_uri)
    dpg_data = JSON.parse(dpg_response)
    dpg_data.each do |entry|
      next if search_in_ignorelist(entry, ignore_list)

      prod = sync_public_product(entry)
      update_repository_data(entry, prod)
    end
    puts 'Digital public good data synced ...'
    send_notification
  end

  task :digi_square_digital_good, [:path] => :environment do
    puts 'Pulling Digital Square Global Goods ...'
    ignore_list = YAML.load_file('config/product_ignorelist.yml')

    digisquare_maturity = JSON.parse(File.open('config/digisquare_maturity_data.json'))
    digisquare_products = YAML.load_file('config/digisquare_global_goods.yml')
    digisquare_products['products'].each do |digi_product|
      next if search_in_ignorelist(digi_product, ignore_list)

      prod = sync_digisquare_product(digi_product, digisquare_maturity)
      update_repository_data(digi_product, prod)
    end

    puts 'Digital square data synced.'
    send_notification
  end

  task :osc_digital_good_local, [] => :environment do
    puts 'Starting pulling data from open source center ...'
    ignore_list = YAML.load_file('config/product_ignorelist.yml')

    osc_file = File.read('utils/digital_global_goods.json')
    osc_data = JSON.parse(osc_file)
    osc_data.each do |product|
      next if search_in_ignorelist(product, ignore_list)

      prod = sync_osc_product(product)
      update_repository_data(product, prod)
    end
    send_notification
  end

  task :purge_removed_products, [:path] => :environment do |_, params|
    puts 'Pulling data from digital public good ...'

    unicef_origin = Origin.find_by(slug: 'unicef')
    unicef_list = []
    Dir.entries(params[:path]).select { |item| item.include?('.json') }.each do |entry|
      entry_data = File.read(File.join(params[:path], entry))

      begin
        json_data = JSON.parse(entry_data)
      rescue JSON::ParserError
        puts "Skipping unparseable json file: #{entry}"
        next
      end

      if !json_data.key?('type') && !json_data.key?('name')
        puts "Skipping unrecognized json file: #{entry}"
        next
      end

      unicef_list.push(json_data['name'])
      unicef_list.push(json_data['initialism']) if json_data.key?('initialism')
    end
    unicef_products = Product.all.joins(:products_origins).where('origin_id=?', unicef_origin.id)

    removed_products = []
    unicef_products.each do |product|
      next unless product.origins.count == 1

      # the product's only origin is Unicef
      removed_products << product.name unless unicef_list.include?(product.name)
    end
    # Send email to admin to remove this product
    msg_string = 'Products no longer in the Unicef list. Please remove from catalog. <br />'\
                 "#{removed_products.join('<br />')}"
    users = User.where(receive_backup: true)
    users.each do |user|
      cmd = "curl -s --user 'api:#{Rails.application.secrets.mailgun_api_key}'"\
            " https://api.mailgun.net/v3/#{Rails.application.secrets.mailgun_domain}/messages"\
            " -F from='Registry <backups@solutions.dial.community>'"\
            " -F to=#{user.email}"\
            " -F subject='Sync task - delete product'"\
            " -F html='#{msg_string}'"
      system cmd
    end
  end

  task :purge_blacklisted_products, [:path] => :environment do |_, _params|
    puts 'Removing products in the blacklist...'
    blacklist = YAML.load_file('config/product_blacklist.yml')
    blacklist.each do |blacklist_item|
      blacklist_product = Product.where(name: blacklist_item['item']).first
      next if blacklist_product.nil?

      puts "Deleting product: #{blacklist_product.name}!"
      blacklist_product.organizations.each do |organization|
        org_products = OrganizationsProduct.where(organization_id: organization.id)
        if org_products.count == 1 && organization.is_endorser != true && organization.is_mni != true
          puts "Deleting organization: #{organization.name}." if organization.destroy
        elsif org_products.count > 1
          curr_org_product = org_products.where(product_id: blacklist_product.id).first
          unless curr_org_product.nil?
            puts "Deleting org product relationship: #{curr_org_product.inspect}."
            delete_statement = "delete from organizations_products where product_id=#{blacklist_product.id}"
            ActiveRecord::Base.connection.execute(delete_statement)
          end
        end
      end
      blacklist_product.organizations.delete_all
      blacklist_product.product_descriptions.each do |description|
        puts "Deleting description: #{description.id}." if description.destroy
      end
      puts "Product: #{blacklist_product.name} deleted." if blacklist_product.destroy
    end
  end

  task :update_banned_products, [:path] => :environment do |_, _params|
    puts 'Updating products in the blacklist...'

    banned_product_setting = Setting.find_by(slug: 'banned_product_list')
    if banned_product_setting.nil?
      banned_product_setting = Setting.new
      banned_product_setting.name = 'Banned Product List'
      banned_product_setting.slug = 'banned_product_list'
      banned_product_setting.description = 'List of banned product. Generated by nightly task.'
    end

    ban_config = YAML.load_file('config/ban_config.yml')
    line_of_code = ban_config['product']['line-of-code']
    undefined_website = ban_config['product']['website-undefined'].to_s == 'true'
    invalid_website = ban_config['product']['website-invalid'].to_s == 'true'

    banned_products = []
    Product.all.each do |product|
      if !line_of_code.nil? && !product.code_lines.nil? && product.code_lines < line_of_code
        puts "Banning #{product.name} due to low line of codes."
        banned_products << product.slug
        next
      end

      if product.website.nil?
        if undefined_website
          puts "Banning #{product.name} due to empty website."
          banned_products << product.slug
        else
          puts "Skipping #{product.name}. Undefined website configuration is false."
        end
        next
      end

      if product.website.index('github.com') && invalid_website
        puts "Banning #{product.name} due to invalid website."
        banned_products << product.slug
        next
      end

      begin
        uri = URI.parse("https://#{product.website}")

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        response = http.head(uri.request_uri)
        puts "Website for #{product.name} is up and valid." if response.code == '200'
      rescue StandardError
        # Try connecting on the non SSL
        begin
          uri = URI.parse("http://#{product.website}")
          http = Net::HTTP.new(uri.host, uri.port)

          response = http.head(uri.request_uri)
          puts "Website for #{product.name} is up, but it is not using SSL." if response.code == '200'
        rescue StandardError => e
          puts "Unable to check website for product: #{product.name}."
          puts "Error message for #{product.website}: #{e}."
          if invalid_website
            banned_products << product.slug
            next
          end
        end
      end
    end
    banned_product_setting.value = banned_products.join(', ')

    puts 'Banned product list updated.' if banned_product_setting.save!
  end

  def extract_description(response_body)
    parsed_response = Nokogiri::HTML(response_body.to_s)

    description = nil
    if description.nil? || description.blank?
      meta_description = parsed_response.at_css('meta[@name="description"]')
      description = meta_description.attr('content') unless meta_description.nil?
    end

    if description.nil? || description.blank?
      twitter_description = parsed_response.at_css('meta[@name="twitter:description"]')
      description = twitter_description.attr('content') unless twitter_description.nil?
    end

    if description.nil? || description.blank?
      og_description = parsed_response.at_css('meta[@property="og:description"]')
      description = og_description.attr('content') unless og_description.nil?
    end

    if description.nil? || description.blank?
      long_paragraphs = parsed_response.search('//p[string-length() >= 120]')
      description = long_paragraphs.first.attr('content') unless long_paragraphs.empty?
    end
    description
  end

  task :fetch_website_data, [:path] => :environment do |_, _params|
    puts 'Updating organization and product description data ...'

    Product.left_joins(:product_descriptions)
           .where(product_descriptions: { id: nil })
           .each do |product|
      next if product.website.nil? || product.website.empty?

      product_description = ProductDescription.where(product_id: product, locale: I18n.locale)
      next unless product_description.empty?

      begin
        puts "(Product) Opening connection to: #{product.website}."
        uri = URI.parse("https://#{product.website}")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)
      rescue StandardError
        begin
          uri = URI.parse("http://#{product.website}")
          http = Net::HTTP.new(uri.host, uri.port)
          request = Net::HTTP::Get.new(uri.request_uri)
          response = http.request(request)
        rescue StandardError => e_retry
          puts "Unable to retrieve meta information. Message: #{e_retry}."
        end
      end
      next if response.nil?

      description = extract_description(response.body)
      next if description.nil?

      product_description = ProductDescription.new
      product_description.product_id = product.id
      product_description.locale = I18n.locale
      product_description.description = description.strip
      puts "Setting description for: #{product.name} => #{description}" if product_description.save!
    end

    Organization.left_joins(:organization_descriptions)
                .where(organization_descriptions: { id: nil })
                .each do |organization|
      next if organization.website.nil? || organization.website.empty?

      org_description = OrganizationDescription.where(organization_id: organization, locale: I18n.locale)
      next unless org_description.empty?

      begin
        puts "(Organization) Opening connection to: #{organization.website}."
        uri = URI.parse("https://#{organization.website}")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        request = Net::HTTP::Get.new(uri.request_uri)
        response = http.request(request)
      rescue StandardError
        begin
          uri = URI.parse("http://#{organization.website}")
          http = Net::HTTP.new(uri.host, uri.port)
          request = Net::HTTP::Get.new(uri.request_uri)
          response = http.request(request)
        rescue StandardError => e_retry
          puts "Unable to retrieve meta information. Message: #{e_retry}."
        end
      end
      next if response.nil?

      description = extract_description(response.body)
      next if description.nil?

      organization_description = OrganizationDescription.new
      organization_description.organization_id = organization.id
      organization_description.locale = I18n.locale
      organization_description.description = description.strip
      if organization_description.save!
        puts "Setting description for: #{organization.name} => #{organization_description.description}"
      end
    end
  end

  desc 'Sync the database with the public goods lists.'
  task :export_public_goods, [:path] => :environment do |_, _params|
    puts 'Exporting OSC and Digital Square global goods ...'

    export_products('dial_osc')
    export_products('digital_square')
  end

  desc 'Create product repositories using parent-child yml file.'
  task :generate_repositories, [:path] => :environment do |_, _params|
    Rails.logger.level = Logger::DEBUG

    product_list = YAML.load_file('config/product_parent_child.yml')
    product_list.each do |product_entry|
      parent_product_name = product_entry['parent'].first['name']
      parent_product = Product.where(name: parent_product_name).first
      next if parent_product.nil?

      repository_attrs = {
        name: "#{parent_product.name} Repository",
        absolute_url: 'N/A',
        description: "Main code repository of #{parent_product.name}.",
        main_repository: true
      }

      main_repository = ProductRepository.find_by(product_id: parent_product.id, name: repository_attrs[:name])
      if main_repository.nil?
        repository_attrs[:product] = parent_product
        repository_attrs[:slug] = slug_em(repository_attrs[:name])
        main_repository = ProductRepository.create!(repository_attrs)
        puts "Created main repository for: #{main_repository.name}."
      else
        puts "Repository exists: #{main_repository.name}."
      end

      product_entry['children'].each do |child_product_entry|
        repository_attrs = {
          name: "#{child_product_entry['name']} Repository",
          absolute_url: 'N/A',
          description: "Code repository of #{child_product_entry['name']}.",
          main_repository: false
        }
        secondary_repository = ProductRepository.find_by(product_id: parent_product.id, name: repository_attrs[:name])
        if secondary_repository.nil?
          repository_attrs[:product] = parent_product
          repository_attrs[:slug] = slug_em(repository_attrs[:name])
          secondary_repository = ProductRepository.create!(repository_attrs)
          puts "    Created secondary repository for: #{secondary_repository.name}."
        else
          puts "    Repository exists: #{secondary_repository.name}."
        end
      end
    end
  end

  task :update_public_goods_repo, [:path] => :environment do |_, params|
    puts 'Updating changes to OSC and Digital Square goods to publicgoods repository'

    export_products('dial_osc')
    export_products('digital_square')

    Dir.entries('./export').select { |item| item.include?('.json') }.each do |entry|
      product_file = entry

      curr_prod = Product.where(slug: entry.chomp('.json').gsub('-', '_')).first
      if curr_prod.nil?
        alias_name = entry.chomp('.json').gsub('-', ' ').downcase
        puts "Alias: #{alias_name}"
        curr_prod = Product.find_by('? = ANY(LOWER(aliases::text)::text[])', alias_name)
      end
      curr_prod['aliases']&.each do |prod_alias|
        alias_file = "#{prod_alias.downcase.gsub(' ', '-')}.json"
        product_file = alias_file if File.exist?("#{params[:path]}/#{alias_file}")
      end

      puts "New product: #{product_file}." unless File.exist?("#{params[:path]}/#{product_file}")
      FileUtils.cp_r("./export/#{entry}", "#{params[:path]}/#{product_file}")
    end
  end

  task :update_license_data, [] => :environment do
    puts 'Starting to pull license data ...'

    ProductRepository.all.each do |product_repository|
      sync_license_information(product_repository)
    end
  end

  task :update_statistics_data, [] => :environment do
    puts 'Starting to pull statistic data ...'

    ProductRepository.all.each do |product_repository|
      sync_product_statistics(product_repository)
    end
  end

  task :update_tco_data, [] => :environment do
    puts 'Updating TCO data for products.'

    ProductRepository.all.each do |product_repository|
      update_tco_data(product_repository)
    end
  end

  task :update_language_data, [] => :environment do
    puts 'Updating language data for products.'

    ProductRepository.all.each do |product_repository|
      sync_product_languages(product_repository)
    end
  end

  task :sync_giz_projects, [] => :environment do
    # First, set all existing sector origins to DIAL
    dial_origin = Origin.find_by(name: 'DIAL OSC')
    Sector.where('origin_id is null').update_all(origin_id: dial_origin.id)

    giz_origin = Origin.find_by(name: 'GIZ')
    if giz_origin.nil?
      giz_origin = Origin.new
      giz_origin.name = 'GIZ'
      giz_origin.slug = slug_em(giz_origin.name)
      giz_origin.description = 'Deutsche Gesellschaft für Internationale Zusammenarbeit (GIZ) GmbH'

      puts 'GIZ as origin is created.' if giz_origin.save
    end

    # Get credentials for Toolkit
    uri = URI('https://digitalportfolio.toolkit-digitalisierung.de/en/wp-json/giz/v1/users/login/')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path)
    request.set_form_data({ 'email' => ENV['TOOLKIT_EMAIL'], 'password' => ENV['TOOLKIT_PASSWORD'] })

    response = http.request(request)
    cookies = response.header['Set-Cookie']

    # Download German and English versions of projects list
    uri = URI('https://digitalportfolio.toolkit-digitalisierung.de/en/projects/export/')

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri.path)
    request['Cookie'] = cookies
    english_response = http.request(request)

    english_csv = CSV.parse(english_response.body, headers: true)

    uri = URI('https://digitalportfolio.toolkit-digitalisierung.de/projects/export/')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri.path)
    request['Cookie'] = cookies
    german_response = http.request(request)

    german_csv = CSV.parse(german_response.body, headers: true)

    english_csv.each_with_index do |english_project, index|
      german_project = german_csv[index]
      sync_giz_project(english_project, german_project, giz_origin)
    end
  end

  task :sync_digital_health_atlas_data, [] => :environment do
    dha_origin = Origin.find_by(name: 'Digital Health Atlas')
    if dha_origin.nil?
      dha_origin = Origin.new
      dha_origin.name = 'Digital Health Atlas'
      dha_origin.slug = slug_em(dha_origin.name)
      dha_origin.description = 'Digital Health Atlas Website'

      puts 'Digital health atlas as origin is created.' if dha_origin.save
    end

    structure_uri = URI.parse('https://digitalatlas.who.int/api/projects/structure/')
    structure_response = Net::HTTP.get(structure_uri)
    structure_data = JSON.parse(structure_response)
    products_data = structure_data['technology_platforms']

    projects_uri = URI.parse('https://digitalatlas.who.int/api/search/?page=1&type=list&page_size=1000')
    projects_response = Net::HTTP.get(projects_uri)
    dha_data = JSON.parse(projects_response)

    country_uri = URI.parse('https://digitalatlas.who.int/api/landing-country/')
    country_response = Net::HTTP.get(country_uri)
    country_data = JSON.parse(country_response)

    org_uri = URI.parse('https://digitalatlas.who.int/api/organisations/')
    org_response = Net::HTTP.get(org_uri)
    org_data = JSON.parse(org_response)

    dha_data['results']['projects'].each do |project|
      project_name = project['name']
      project_slug = slug_em(project_name, 64)
      existing_project = Project.find_by(slug: project_slug, origin_id: dha_origin.id)

      if existing_project.nil?
        existing_project = Project.new
        existing_project.name = project_name
        existing_project.slug = project_slug
        existing_project.origin = dha_origin
      end

      country_id = project['country']
      next if country_id.nil?

      country_name = country_data.select { |country| country['id'] == country_id }[0]['name']
      country = Country.find_by(name: country_name)
      existing_project.countries << country if !country.nil? && !existing_project.countries.include?(country)

      # There's two date. We will always try to use the start date.
      # If start date is nil, then we will try to use the implementing date.
      start_date = project['start_date']
      start_date = project['implementation_dates'] if start_date.nil?

      unless start_date.nil?
        begin
          existing_project.start_date = Date.parse(start_date.to_s)
        rescue ArgumentError
          puts "Invalid start date: #{start_date}"
        end
      end

      end_date = project['end_date']
      unless end_date.nil?
        begin
          existing_project.end_date = Date.parse(end_date.to_s)
        rescue ArgumentError
          puts "Invalid end date: #{end_date}"
        end
      end

      description = "<p>#{project['implementation_overview']}</p>"

      sector = Sector.find_by(name: 'Health')
      existing_project.sectors << sector unless existing_project.sectors.include?(sector)

      project_description = ProjectDescription.find_by(project_id: existing_project.id, locale: I18n.locale)
      if project_description.nil?
        project_description = ProjectDescription.new
        project_description.locale = I18n.locale
        project_description.description = description

        existing_project.project_descriptions << project_description
      else
        project_description.description = description
        project_description.save!
      end

      project['platforms'].each do |platform|
        product = products_data.select { |p| p['id'] == platform['id'] }[0]
        next if product.nil?

        product_name = product['name']
        slug = slug_em(product_name)
        product = Product.first_duplicate(product_name, slug)
        next if product.nil?

        existing_project.products << product unless existing_project.products.include?(product)
      end

      project_url = "https://digitalhealthatlas.org/#{I18n.locale}/-/projects/#{project['id']}/published"
      existing_project.project_url = project_url

      puts "Project #{existing_project.name} saved!" if existing_project.save!

      org_id = project['organisation']
      org_name = org_data.select { |org| org['id'] == org_id }[0]['name']
      org = Organization.name_contains(org_name)

      if !org.empty? && !existing_project.organizations.include?(org[0])
        proj_org = ProjectsOrganization.new
        proj_org.org_type = 'owner'
        proj_org.project_id = existing_project.id
        proj_org.organization_id = org[0].id
        proj_org.save!
      end

      project['donors']&.each do |donor|
        donor_name = org_data.select { |o| o['id'] == donor }[0]['name']
        donor_org = Organization.name_contains(donor_name)

        next unless !donor_org.empty? && !existing_project.organizations.include?(donor_org[0])

        proj_org = ProjectsOrganization.new
        proj_org.org_type = 'funder'
        proj_org.project_id = existing_project.id
        proj_org.organization_id = donor_org[0].id
        proj_org.save!
      end

      project['implementing_partners']&.each do |implementer|
        implementer_org = Organization.name_contains(implementer)

        next unless !implementer_org.empty? && !existing_project.organizations.include?(implementer_org[0])

        proj_org = ProjectsOrganization.new
        proj_org.org_type = 'implementer'
        proj_org.project_id = existing_project.id
        proj_org.organization_id = implementer_org[0].id
        proj_org.save!
      end
    end
  end

  task :import_dha_projects, [] => :environment do
    structure_uri = URI.parse('https://qa.whomaps.pulilab.com/api/projects/structure/')
    structure_response = Net::HTTP.get(structure_uri)
    structure_data = JSON.parse(structure_response)
    products_data = structure_data['technology_platforms']

    country_uri = URI.parse('https://qa.whomaps.pulilab.com/api/landing-country/')
    country_response = Net::HTTP.get(country_uri)
    country_data = JSON.parse(country_response)

    org_uri = URI.parse('https://qa.whomaps.pulilab.com/api/organisations/')
    org_response = Net::HTTP.get(org_uri)
    org_data = JSON.parse(org_response)

    project_url = URI.parse('https://qa.whomaps.pulilab.com/api/projects/external/publish/')

    mm_csv = CSV.parse(File.read('export/MMData.csv'), headers: true)
    mm_csv.each do |mm_row|
      # Find the country
      mm_country = country_data.find { |country| country['name'].include?(mm_row[0]) }['id']

      # Find the org
      unless mm_row[4].nil?
        mm_org = org_data.find { |org| org['name'].downcase.delete(' ') == mm_row[4].downcase.delete(' ') }
        unless mm_org.nil?
          mm_org_name = mm_org['name']
        end
      end

      # Find products
      mm_platforms = JSON.parse('[]')
      unless mm_row[2].nil?
        mm_products = mm_row[2].split(',')
        mm_products.each do |mm_product|
          curr_prod = products_data.find { |prod| prod['name'].downcase.delete(' ') == mm_product.downcase.delete(' ') }
          mm_platforms << { 'id': curr_prod['id'] } unless curr_prod.nil?
        end
      end

      params = { 'project': { 'name': "Map & Match - #{mm_row[1]}",
                              'organization': mm_org_name,
                              'country': mm_country,
                              'contact_name': mm_row[9],
                              'contact_email': mm_row[10],
                              'implementation_overview': mm_row[3],
                              'platforms': mm_platforms,
                              'start_date': mm_row[12],
                              'health_focus_areas': mm_row[6] == 'yes' ? [{ 'id': 20 }] : [] } }
      headers = {
        'Authorization' => "Bearer ENV['DHA_TOKEN']",
        'Content-Type' => 'application/json'
      }

      puts "Parameters: #{params.to_json}"

      http = Net::HTTP.new(project_url.host, project_url.port)
      response = http.post(project_url.path, params.to_json, headers)

      puts "Response: #{response}"
    end
  end
end
