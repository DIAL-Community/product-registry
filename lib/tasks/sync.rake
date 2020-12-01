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
            blacklist_product.organizations.delete_all
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
        puts entry
        
        curr_prod = Product.where(slug: entry.chomp('.json').gsub("-","_")).first
        if curr_prod.nil? 
          alias_name = entry.chomp('.json').gsub("-", " ").downcase
          puts "ALIAS: " + alias_name
          curr_prod = Product.find_by("? = ANY(LOWER(aliases::text)::text[])", alias_name)
        end
        curr_prod['aliases'] && curr_prod['aliases'].each do |prod_alias|
          alias_file = prod_alias.downcase.gsub(" ","-")+".json"
          if File.exist?(params[:path]+"/"+alias_file)
            product_file = alias_file
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

  task :update_language_data, [] => :environment do
    puts 'Updating language data for products.'

    Product.all.each do |product|
      sync_product_languages(product)
    end
  end

  task :sync_giz_sectors, [] => :environment do
    # First, set all existing sector origins to DIAL
    dial_origin = Origin.find_by(name: 'DIAL OSC')
    Sector.where('origin_id is null').update_all origin_id: dial_origin.id

    giz_origin = Origin.find_by(name: 'GIZ')
    if giz_origin.nil?
      giz_origin = Origin.new
      giz_origin.name = 'GIZ'
      giz_origin.slug = slug_em giz_origin.name
      giz_origin.description = 'Deutsche Gesellschaft für Internationale Zusammenarbeit (GIZ) GmbH'

      if giz_origin.save
        puts 'GIZ as origin is created.'
      end
    end

    project_list = CSV.parse(File.read('utils/GIZ_Projects.csv'), headers: true)

    project_list.each do |project|
      sector_name = project[19]
      if !sector_name.nil?
        sector_name = sector_name.strip
        sector_slug = slug_em sector_name
        existing_sector = Sector.find_by(slug: sector_slug, origin_id: giz_origin.id)
        puts "Sector Name: " + sector_name
        if existing_sector.nil?
          new_sector = Sector.new
          new_sector.name = sector_name
          new_sector.slug = sector_slug
          new_sector.origin_id = giz_origin.id
          new_sector.is_displayable = true
          new_sector.save!
          puts "Sector Created"

          existing_sector = Sector.find_by(slug: sector_slug, origin_id: giz_origin.id)
        else
          puts "Sector exists"
        end
        subsectors = project[20]
        if !subsectors.nil? 
          subsector_array = subsectors.split(',')
          subsector_array.each do |subsector|
            subsector = subsector.strip
            subsector_slug = slug_em subsector
            puts "Subsector: " + subsector
            existing_subsector = Sector.find_by(slug: subsector_slug, parent_sector_id: existing_sector.id, origin_id: giz_origin.id)
            if existing_subsector.nil?
              new_sector = Sector.new
              new_sector.name = sector_name + ": " + subsector
              new_sector.slug = subsector_slug
              new_sector.origin_id = giz_origin.id
              new_sector.is_displayable = true
              new_sector.parent_sector_id = existing_sector.id
              new_sector.save!
              puts "Sub-Sector Created"
            else
              puts "Subsector exists"
            end
          end
        end
      end
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

    structure_uri = URI.parse("https://qa.whomaps.pulilab.com/api/projects/structure/")
    structure_response = Net::HTTP.get(structure_uri)
    structure_data = JSON.parse(structure_response)
    products_data = structure_data["technology_platforms"]

    projects_uri = URI.parse("https://qa.whomaps.pulilab.com/api/search/?page=1&type=list&page_size=500")
    projects_response = Net::HTTP.get(projects_uri)
    dha_data = JSON.parse(projects_response)

    country_uri = URI.parse("https://qa.whomaps.pulilab.com/api/landing-country/")
    country_response = Net::HTTP.get(country_uri)
    country_data = JSON.parse(country_response)

    org_uri = URI.parse("https://qa.whomaps.pulilab.com/api/organisations/")
    org_response = Net::HTTP.get(org_uri)
    org_data = JSON.parse(org_response)

    dha_data["results"]["projects"].each do |project|
      project_name = project["name"]

      existing_project = Project.find_by(name: project_name, origin_id: dha_origin.id)
      
      if existing_project.nil?
        existing_project = Project.new
        existing_project.name = project_name
        existing_project.slug = slug_em existing_project.name
        existing_project.origin = dha_origin
      end

      country_id = project["country"]
      country_name = country_data.select {|country| country["id"] == country_id }[0]["name"]
      location = Location.find_by(name: country_name, location_type: 'country')
      if !location.nil?
        if !existing_project.locations.include?(location)
          existing_project.locations << location
        end
      end

      # There's two date. We will always try to use the start date.
      # If start date is nil, then we will try to use the implementing date.
      start_date = project["start_date"]
      if start_date.nil?
        start_date = project["implementation_dates"]
      end

      if !start_date.nil?
        begin
          existing_project.start_date = Date.parse(start_date.to_s)
        rescue ArgumentError
          puts "Invalid start date: #{start_date}"
        end
      end

      end_date = project["end_date"]
      if !end_date.nil?
        begin
          existing_project.end_date = Date.parse(end_date.to_s)
        rescue ArgumentError
          puts "Invalid end date: #{end_date}"
        end
      end

      description = "<p>"+project["implementation_overview"]+"</p>"
  
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

      project["platforms"].each do |platform|
        product = products_data.select {|product| product["id"] == platform["id"] }[0]
        next if product.nil?
        product_name = product["name"] 
        slug = slug_em product_name
        product = Product.first_duplicate(product_name, slug)
        if !product.nil?
          if !existing_project.products.include?(product)
            existing_project.products << product
          end
        end
      end

      project_url = "https://digitalhealthatlas.org/"+I18n.locale.to_s+"/-/projects/"+project["id"].to_s+"/published"
      existing_project.project_url = project_url

      if existing_project.save!
        puts "Project #{existing_project.name} saved!"
      end
      
      org_id = project["organisation"]
      org_name = org_data.select {|org| org["id"] == org_id }[0]["name"]
      org = Organization.name_contains(org_name)
      
      if !org.empty? && !existing_project.organizations.include?(org[0])  
        proj_org = ProjectsOrganization.new
        proj_org.org_type = 'owner'
        proj_org.project_id = existing_project.id
        proj_org.organization_id = org[0].id
        proj_org.save!
      end

      project["donors"] && project["donors"].each do |donor|
        donor_name = org_data.select {|org| org["id"] == donor }[0]["name"]
        donor_org = Organization.name_contains(donor_name)

        if !donor_org.empty? && !existing_project.organizations.include?(donor_org[0])
          proj_org = ProjectsOrganization.new
          proj_org.org_type = 'funder'
          proj_org.project_id = existing_project.id
          proj_org.organization_id = donor_org[0].id
          proj_org.save!
        end
      end

      project["implementing_partners"] && project["implementing_partners"].each do |implementer|
        implementer_org = Organization.name_contains(implementer)

        if !implementer_org.empty? && !existing_project.organizations.include?(implementer_org[0])
          proj_org = ProjectsOrganization.new
          proj_org.org_type = 'implementer'
          proj_org.project_id = existing_project.id
          proj_org.organization_id = implementer_org[0].id
          proj_org.save!
        end
      end
    end
  end
end
