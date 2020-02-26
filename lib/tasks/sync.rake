require 'modules/slugger'
require 'modules/sync'
include Modules::Slugger
include Modules::Sync

namespace :sync do
  desc 'Sync the database with the public goods lists.'
  task :public_goods, [:path] => :environment do |_, params|
    puts 'Pulling data from digital public good ...'

    Dir.entries(params[:path]).select { |item| item.include? '.json' }.each do |entry|
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

      sync_public_product json_data
    end
    puts 'Digital public good data synced ...'
    send_notification
  end

  # Note: this will be deprecated once all data has been brought into the common publicgoods repository
  desc 'Sync the database with the public goods lists.'
  task :unicef_goods, [:path] => :environment do |_, params|
    puts 'Pulling data from digital public good ...'

    Dir.entries(params[:path]).select { |item| item.include? '.json' }.each do |entry|
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

      sync_unicef_product json_data
    end
    puts 'Digital public good data synced ...'
    send_notification
  end

  task :digi_square_digital_good, [:path] => :environment do
    puts 'Pulling Digital Square Global Goods ...'

    digisquare_products = YAML.load_file('config/digisquare_global_goods.yml')
    digisquare_products['products'].each do |digi_product|
      sync_digisquare_product digi_product
    end

    puts 'Digital square data synced.'
    send_notification
  end

  task :osc_digital_good, [:path] => :environment do
    puts 'Starting pulling data from open source center ...'

    osc_location = 'https://www.osc.dial.community/digital_global_goods.json'
    osc_uri = URI.parse(osc_location)
    osc_response = Net::HTTP.get(osc_uri)
    osc_data = JSON.parse(osc_response)
    osc_data.each do |product|
      sync_osc_product product
    end
    send_notification
  end

  task :purge_removed_products, [:path] => :environment do |_, params|
    puts 'Pulling data from digital public good ...'

    unicef_origin = Origin.find_by(slug: 'unicef')
    unicef_list = []
    Dir.entries(params[:path]).select { |item| item.include? '.json' }.each do |entry|
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
      if json_data.key?('initialism')
        unicef_list.push(json_data['initialism'])
      end
    end
    unicef_products = Product.all.joins(:products_origins).where('origin_id=?', unicef_origin.id)
    unicef_products.each do |product|
      if product.origins.count == 1
        # the product's only origin is Unicef
        if !unicef_list.include?(product.name)
          # Send email to admin to remove this product
          msg_string = "Product #{product.name} is no longer in the Unicef list. Please remove from catalog."
          users = User.where(receive_backup: true)
          users.each do |user|
            cmd = "curl -s --user 'api:#{Rails.application.secrets.mailgun_api_key}'"\
                  " https://api.mailgun.net/v3/#{Rails.application.secrets.mailgun_domain}/messages"\
                  " -F from='Registry <backups@registry.dial.community>'"\
                  " -F to=#{user.email}"\
                  " -F subject='Sync task - delete product'"\
                  " -F text='#{msg_string}'"
            system cmd
          end
        end
      end
    end
  end

  desc 'Sync the database with the public goods lists.'
  task :export_public_goods, [:path] => :environment do |_, params|
    puts 'Exporting OSC and Digital Square global goods ...'

    session = ActionDispatch::Integration::Session.new(Rails.application)
    session.get "/productlist?source=dial_osc"
    prod_list = JSON.parse(session.response.body)
    prod_list.each do |prod|
      File.open("export/"+slug_em(prod['name'])+".json","w") do |f|
        f.write(JSON.pretty_generate prod)
      end
    end

    session.get "/productlist?source=digital_square"
    prod_list = JSON.parse(session.response.body)
    prod_list.each do |prod|
      File.open("export/"+slug_em(prod['name'])+".json","w") do |f|
        f.write(JSON.pretty_generate prod)
      end
    end
  end

  task :update_version_data, [] => :environment do
    puts 'Starting to pull version data ...'

    Product.all.each do |product|
      sync_product_versions(product)
    end
  end

  task :update_license_data, [] => :environment do
    puts 'Starting to pull license data ...'

    Product.all.each do |product|
      sync_license_information(product)
    end
  end

  task :update_statistics_data, [] => :environment do
    puts 'Starting to pull statistic data ...'

    Product.all.each do |product|
      sync_product_statistics(product)
    end
  end

  task :update_locations_data, [] => :environment do
    puts 'Starting to update location data ...'
    countries = YAML.load_file('config/country_lookup.yml')

    country_lookup = {}
    countries['countries'].each do |country|
      country_lookup[country['country_code']] = country['country_name']
    end

    access_token = authenticate_user

    Location.where(location_type: 'point').each do |location|
      clean_location_data(location, country_lookup, access_token)
    end
  end

  task :sync_digital_health_atlas_data, [] => :environment do
    dha_origin = Origin.find_by(name: 'Digital Health Atlas')
    if dha_origin.nil?
      dha_origin = Origin.new
      dha_origin.name = 'Digital Health Atlas'
      dha_origin.slug = slug_em dha_origin.name
      dha_origin.description = 'Digital Health Atlas Website'

      if dha_origin.save
        puts 'Digital health atlas as origin is created.'
      end
    end

    csv_table = CSV.parse(File.read('utils/DHA-Data.csv'), headers: true)

    csv_table.each do |csv_row|
      project_name = csv_row[0]

      existing_project = Project.find_by(name: project_name)
      next unless existing_project.nil?

      existing_project = Project.new
      existing_project.name = project_name
      existing_project.slug = slug_em existing_project.name
      existing_project.origin = dha_origin

      country_name = csv_row['Country']
      location = Location.find_by(name: country_name, location_type: 'country')
      if !location.nil?
        existing_project.locations << location
      end

      # There's two date. We will always try to use the start date.
      # If start date is nil, then we will try to use the implementing date.
      start_date = csv_row['Start Date']
      if start_date.nil?
        start_date = csv_row['Implementing Date']
      end

      if !start_date.nil?
        begin
          existing_project.start_date = Date.parse(start_date.to_s)
        rescue ArgumentError
          puts "Invalid start date: #{start_date}"
        end
      end

      end_date = csv_row['End Date']
      if !end_date.nil?
        begin
          existing_project.end_date = Date.parse(csv_row['End Date'].to_s)
        rescue ArgumentError
          puts "Invalid end date: #{csv_row['End Date']}"
        end
      end

      description = {
        ops: [
          insert: csv_row['Overview of digital health implementation']
        ]
      }

      project_description = ProjectDescription.new
      project_description.locale = I18n.locale
      project_description.description = description

      existing_project.project_descriptions << project_description

      product = Product.find_by(name: csv_row['Software'])
      if !product.nil?
        existing_project.products << product
      end

      organizations = Set.new
      organization = Organization.find_by(name: csv_row['Organisation Name'])
      !organization.nil? && organizations.add(organization)

      organization = Organization.find_by(name: csv_row['Donors'])
      !organization.nil? && organizations.add(organization)

      organization = Organization.find_by(name: csv_row['Implementing Partners'])
      !organization.nil? && organizations.add(organization)

      existing_project.organizations = organizations.to_a

      if existing_project.save!
        puts "Project #{existing_project.name} saved!"
      end
    end
  end
end
