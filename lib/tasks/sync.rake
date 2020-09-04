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

    digisquare_maturity = JSON.load(File.open("config/digisquare_maturity_data.json"))
    digisquare_products = YAML.load_file('config/digisquare_global_goods.yml')
    digisquare_products['products'].each do |digi_product|
      sync_digisquare_product(digi_product, digisquare_maturity)
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

    removed_products = []
    unicef_products.each do |product|
      if product.origins.count == 1
        # the product's only origin is Unicef
        if !unicef_list.include?(product.name)
          removed_products << product.name
        end
      end
    end
    # Send email to admin to remove this product
    msg_string = "Products no longer in the Unicef list. Please remove from catalog. <br />#{removed_products.join('<br />')}"
    users = User.where(receive_backup: true)
    users.each do |user|
      cmd = "curl -s --user 'api:#{Rails.application.secrets.mailgun_api_key}'"\
            " https://api.mailgun.net/v3/#{Rails.application.secrets.mailgun_domain}/messages"\
            " -F from='Registry <backups@registry.dial.community>'"\
            " -F to=#{user.email}"\
            " -F subject='Sync task - delete product'"\
            " -F html='#{msg_string}'"
      system cmd
    end
  end

  task :purge_blacklisted_products, [:path] => :environment do |_, params|
    puts 'Removing products in the blacklist...'
    blacklist = YAML.load_file('config/product_blacklist.yml')
        blacklist.each do |blacklist_item|
          blacklist_product = Product.where(name: blacklist_item['item']).first
          if !blacklist_product.nil?
            puts "Deleting "+blacklist_product.name
            blacklist_product.organizations.each do |org|
              org_products = OrganizationsProduct.where(organization_id: org.id)
              if org_products.count == 1 && org.is_endorser != true && org.is_mni != true
                puts "Deleting ORG: " +org.name
                org.destroy
              elsif org_products.count > 1
                curr_org_product = org_products.where(product_id: blacklist_product.id).first
                if !curr_org_product.nil?
                  puts "DELETING ORG PRODUCT RELATIONSHIP: " + curr_org_product.inspect
                  results = ActiveRecord::Base.connection.execute("delete from organizations_products where product_id="+blacklist_product.id.to_s)
                  #deleted_org_prod = OrganizationsProduct.where(product_id: blacklist_product.id).destroy_all
                end
              end
              
            end
            blacklist_product.product_versions.each do |version|
              puts "Deleting "+version.version
              version.destroy
            end
            blacklist_product.product_descriptions.each do |description|
              description.destroy
            end
            #blacklist_product.sustainable_development_goals.each do |prod_sdg|
            #  puts "Deleting "+prod_sdg.number.to_s
            #  prod_sdg.destroy
            #end
            blacklist_product.destroy
          end
        end
  end

  desc 'Sync the database with the public goods lists.'
  task :export_public_goods, [:path] => :environment do |_, params|
    puts 'Exporting OSC and Digital Square global goods ...'

    export_products('dial_osc')
    export_products('digital_square')
  
  end

  desc 'Create parent-child links for products that have multiple repos'
  task :link_products, [:path] => :environment do |_, params|
    product_list = YAML.load_file("config/product_parent_child.yml")
    product_list.each do |curr_product|
      parent_product = curr_product["parent"].first
      parent_prod = Product.where(name: parent_product["name"]).first
      if !parent_prod.nil?
        curr_product["children"].each do |child_product|
          child_prod = Product.where(name: child_product["name"]).first
          if !child_prod.nil?
            puts "Adding "+child_prod.name+" as child to "+parent_prod.name
            child_prod.is_child=true
            child_prod.parent_product_id=parent_prod.id
            child_prod.save
          end
        end
      end
    end
  end

  task :update_public_goods_repo, [:path] => :environment do |_, params|
    puts 'Updating changes to OSC and Digital Square goods to publicgoods repository'

    export_products('dial_osc')
    export_products('digital_square')

    Dir.entries('./export').select { |item| item.include? '.json' }.each do |entry|
      product_file = entry
      if !File.exist?('./products/'+product_file)
        puts entry
        
        curr_prod = Product.where(slug: entry.chomp('.json').gsub("-","_")).first
        if curr_prod.nil? 
          alias_name = entry.chomp('.json').gsub("-", " ").titlecase.gsub(" And ", " and ")
          curr_prod = Product.find_by("? = ANY(aliases)", alias_name)
        end
        curr_prod['aliases'] && curr_prod['aliases'].each do |prod_alias|
          alias_file = prod_alias.downcase.gsub(" ","-")+".json"
          if File.exist?(params[:path]+"/"+alias_file)
            product_file = alias_file
          end
        end
      end
      if File.exist?(params[:path]+"/"+product_file)
        FileUtils.cp_r("./export/"+entry, params[:path]+"/"+product_file)
      else
        puts "NEW PRODUCT: " + product_file
        FileUtils.cp_r("./export/"+entry, params[:path]+"/"+product_file)
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

  task :update_tco_data, [] => :environment do
    puts 'Updating TCO data for products.'

    Product.all.each do |product|
      update_tco_data(product)
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

      description = "<p>"+csv_row['Overview of digital health implementation']+"</p>"
  

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
