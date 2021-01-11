require 'modules/slugger'
include Modules::Slugger

module Modules
  module Sync
    @@product_list = []

    # Note: This will be deprecated once all data has been published to new publicgoods repository
    def sync_unicef_product(json_data)
      if !json_data['type'].detect { |element| element.downcase == 'software' }.nil?
        unicef_origin = Origin.find_by(slug: 'unicef')
        name_aliases = [json_data['name'], json_data['initialism']].reject { |x| x.nil? || x.empty? }

        blacklist = YAML.load_file('config/product_blacklist.yml')
        blacklist.each do |blacklist_item|
          if json_data['name'] == blacklist_item['item']
            puts "Skipping #{json_data['name']}"
            return
          end
        end
        existing_product = nil
        is_new = false
        name_aliases.each do |name_alias|
          # Find by name, and then by aliases and then by slug.
          break unless existing_product.nil?

          slug = slug_em name_alias
          existing_product = Product.first_duplicate(name_alias, slug)
        end

        website = cleanup_url(json_data['website'])
        repository = cleanup_url(json_data['repo_main'])

        if existing_product.nil?
          existing_product = Product.new
          existing_product.name = name_aliases.first
          existing_product.slug = slug_em existing_product.name
          @@product_list << existing_product.name
          is_new = true
        end

        existing_product.website = website
        existing_product.repository = repository

        # Assign what's left in the alias array as aliases.
        existing_product.aliases.concat(name_aliases.reject { |x| x == existing_product.name }).uniq!

        # Set the origin to be 'unicef'
        if !existing_product.origins.exists?(id: unicef_origin.id)
          existing_product.origins.push(unicef_origin)
        end

        sdgs = json_data['SDGs']
        if !sdgs.nil? && !sdgs.empty?
          sdgs.each do |sdg|
            sdg_obj = SustainableDevelopmentGoal.find_by(number: sdg)
            assign_sdg_to_product(sdg_obj, existing_product,
                                  ProductSustainableDevelopmentGoal.mapping_status_types[:SELF_REPORTED])
          end
        end

        existing_product.save
        
        if is_new
          update_product_description(existing_product, json_data['description'])
        end
      end
    end

    def sync_public_product(json_data)
      if !json_data['type'].detect { |element| element.downcase == 'software' || element.downcase == 'data' }.nil?
        puts "SYNCING " + json_data.to_s
        unicef_origin = Origin.find_by(slug: 'unicef')
        name_aliases = [json_data['name']]
        if !json_data['aliases'].nil?
          name_aliases += json_data['aliases']
        end

        blacklist = YAML.load_file('config/product_blacklist.yml')
        blacklist.each do |blacklist_item|
          if json_data['name'] == blacklist_item['item']
            puts "Skipping #{json_data['name']}"
            return
          end
        end
        existing_product = nil
        is_new = false
        name_aliases.each do |name_alias|
          # Find by name, and then by aliases and then by slug.
          break unless existing_product.nil?

          slug = slug_em name_alias
          existing_product = Product.first_duplicate(name_alias, slug)
          # Check to see if both just have the same alias. In this case, it's not a duplicate 
          
        end

        if existing_product.nil?
          existing_product = Product.new
          existing_product.name = name_aliases.first
          existing_product.slug = slug_em existing_product.name
          @@product_list << existing_product.name
          is_new = true
        end

        # Assign what's left in the alias array as aliases.
        existing_product.aliases.concat(name_aliases.reject { |x| x == existing_product.name }).uniq!

        # Set the origin to be 'unicef'
        if !existing_product.origins.exists?(id: unicef_origin.id)
          existing_product.origins.push(unicef_origin)
        end

        sdgs = json_data['SDGs']
        if !sdgs.nil? && !sdgs.empty?
          sdgs.each do |sdg|
            sdg_obj = SustainableDevelopmentGoal.find_by(number: sdg.first)
            assign_sdg_to_product(sdg_obj, existing_product,
                                  ProductSustainableDevelopmentGoal.mapping_status_types[:SELF_REPORTED])
          end
        end

        sectors = json_data['sectors']
        if !sectors.nil? && !sectors.empty?
          sectors.each do |sector|
            sector_obj = Sector.find_by(name: sector)
            if sector_obj.nil?
              # Create the sector
              puts "Creating Sector: " + sector
              sector_obj = Sector.new
              sector_obj.name = sector
              sector_obj.slug = slug_em(sector)
              sector_obj.save!
            end
            # Check to see if the sector exists already
            if !existing_product.sectors.include?(sector_obj)
              puts "Adding sector " + sector_obj.name + " to product"
              existing_product.sectors << sector_obj
            end
          end
        end

        if json_data['type'][0].downcase == 'data'
          existing_product.product_type = 'dataset'
        end

        # Update specific information that we need to save for later syncing
        existing_product.publicgoods_data["name"] = json_data["name"]
        existing_product.publicgoods_data["aliases"] = json_data["aliases"]
        existing_product.publicgoods_data["stage"] = json_data["stage"]

        if json_data["stage"] == "DPG"
          existing_product.status = Product::VETTED
        end

        existing_product.save

        update_attributes(json_data, existing_product)

        existing_product.save

        update_product_description(existing_product, json_data['description'])
      end
    end

    def sync_digisquare_product(digi_product, digisquare_maturity)
      digisquare_origin = Origin.find_by(slug: 'digital_square')

      name_aliases = [digi_product['name']]
      digi_product['aliases'] && digi_product['aliases'].each do |name_alias|
        name_aliases.push(name_alias)
      end
      
      existing_product = nil
      is_new = false
      name_aliases.each do |name_alias|
        # Find by name, and then by aliases and then by slug.
        break unless existing_product.nil?

        slug = slug_em name_alias
        existing_product = Product.first_duplicate(name_alias, slug)
      end

      if existing_product.nil?
        existing_product = Product.new
        candidate_slug = slug_em(digi_product['name'])
        existing_product.name = digi_product['name']
        existing_product.slug = slug_em digi_product['name']
        @@product_list << existing_product.name
        is_new = true
      end

      puts existing_product.origins.inspect
      if !existing_product.origins.exists?(id: digisquare_origin.id)
        existing_product.origins.push(digisquare_origin)
      end

      # This will update website, license, repo URL, organizations, and SDGs
      update_attributes(digi_product, existing_product)

      sdgs = digi_product['SDGs']
      if !sdgs.nil? && !sdgs.empty?
        sdgs.each do |sdg|
          sdg_obj = SustainableDevelopmentGoal.where(number: sdg)[0]
          assign_sdg_to_product(sdg_obj, existing_product,
                                ProductSustainableDevelopmentGoal.mapping_status_types[:VALIDATED])
        end
      end

      # Find maturity data if it exists and update
      digisquare_maturity.each do |ds_maturity|
        if existing_product.name == ds_maturity["name"]
          # Get the legacy rubric
          maturity_rubric = MaturityRubric.find_by(slug: 'legacy_rubric')
          if !maturity_rubric.nil?
            ds_maturity["maturity"].each do |key, value|
              # Find the correct category and indicator
              categories = RubricCategory.where(maturity_rubric_id: maturity_rubric.id).map(&:id)
              category_indicator = CategoryIndicator.find_by(rubric_category: categories, name: key)
              # Save the value in ProductIndicators
              product_indicator = ProductIndicator.where(product_id: existing_product.id, category_indicator_id: category_indicator.id)
                                                      .first || ProductIndicator.new
              product_indicator.product_id = existing_product.id
              product_indicator.category_indicator_id = category_indicator.id
              product_indicator.indicator_value = value
              product_indicator.save!
            end
          end
        end
      end

      existing_product.save
      if is_new
        update_product_description(existing_product, digi_product['description'])
      end
      puts "Product updated: #{existing_product.name} -> #{existing_product.slug}."
    end

    def sync_osc_product(product)
      puts "Syncing #{product['name']} ..."
      name_aliases = [product['name']]
      product['aliases'] && product['aliases'].each do |name_alias|
        name_aliases.push(name_alias)
      end
      
      sync_product = nil
      is_new = false
      name_aliases.each do |name_alias|
        # Find by name, and then by aliases and then by slug.
        break unless sync_product.nil?

        slug = slug_em name_alias
        sync_product = Product.first_duplicate(name_alias, slug)
      end
      if sync_product.nil?
        sync_product = Product.new
        sync_product.name = product['name']
        sync_product.slug = slug_em product['name']
        if sync_product.save
          puts "  Added new product: #{sync_product.name} -> #{sync_product.slug}"
        end
        @@product_list << sync_product.name
      end

      if sync_product.nil?
        sync_product = Product.new
        sync_product.name = name_aliases.first
        sync_product.slug = slug_em existing_product.name
        @@product_list << existing_product.name
        is_new = true
      end

      # This will update website, license, repo URL, organizations, and SDGs
      update_attributes(product, sync_product)

      sdgs = product['SDGs']
      if !sdgs.nil? && !sdgs.empty?
        sdgs.each do |sdg|
          sdg_obj = SustainableDevelopmentGoal.where(number: sdg)[0]
          assign_sdg_to_product(sdg_obj, sync_product,
                                ProductSustainableDevelopmentGoal.mapping_status_types[:VALIDATED])
        end
      end

      maturity = product['maturity']
      if !maturity.nil?
        # Get the legacy rubric
        maturity_rubric = MaturityRubric.find_by(slug: 'legacy_rubric')
        if !maturity_rubric.nil?
          maturity.each do |key, value|
            # Find the correct category and indicator
            categories = RubricCategory.where(maturity_rubric_id: maturity_rubric.id).map(&:id)
            category_indicator = CategoryIndicator.find_by(rubric_category: categories, slug: key)
            # Save the value in ProductIndicators
            product_indicator = ProductIndicator.where(product_id: sync_product.id, category_indicator_id: category_indicator.id)
                                                    .first || ProductIndicator.new
            product_indicator.product_id = sync_product.id
            product_indicator.category_indicator_id = category_indicator.id
            product_indicator.indicator_value = value
            product_indicator.save!
          end
        end
      end

      osc_origin = Origin.find_by(slug: 'dial_osc')
      if !sync_product.origins.exists?(id: osc_origin.id)
        sync_product.origins.push(osc_origin)
      end

      sync_product.save
      if is_new
        description = product['description']
        if !description.nil? && !description.empty?
          update_product_description(sync_product, description)
        end
      end
    end

    def assign_sdg_to_product(sdg_obj, product_obj, mapping_status)
      if !sdg_obj.nil? 
        prod_sdg = ProductSustainableDevelopmentGoal.where(sustainable_development_goal_id: sdg_obj.id, product_id: product_obj.id)
        if prod_sdg.empty?
          puts "Adding sdg #{sdg_obj.number} to product"
          new_prod_sdg = ProductSustainableDevelopmentGoal.new
          new_prod_sdg.sustainable_development_goal_id = sdg_obj.id
          new_prod_sdg.product_id = product_obj.id
          new_prod_sdg.mapping_status = mapping_status

          new_prod_sdg.save
        elsif prod_sdg.first.mapping_status.nil?
          product_obj.sustainable_development_goals.delete(sdg_obj)
          new_prod_sdg = ProductSustainableDevelopmentGoal.new
          new_prod_sdg.sustainable_development_goal_id = sdg_obj.id
          new_prod_sdg.product_id = product_obj.id
          new_prod_sdg.mapping_status = mapping_status

          new_prod_sdg.save
        end
      end
    end

    def update_attributes(product, sync_product)
      website = cleanup_url(product['website'])
      if !website.nil? && !website.empty?
        puts "  Updating website: #{sync_product.website} => #{website}"
        sync_product.website = website
      end

      license = product['license']
      if !license.nil? && !license.empty?
        puts "  Updating license: #{sync_product.license} => #{license}"
        if !license.kind_of?(Array)
          sync_product.license = license
        else
          sync_product.license = license.first['spdx']
          sync_product.publicgoods_data["licenseURL"] = license.first['licenseURL']
        end
      end

      repository = product['repositoryURL']
      if !repository.nil? && !repository.empty?
        puts "  Updating repository: #{sync_product.repository} => #{repository}"
        sync_product.repository = repository
      end

      organizations = product['organizations']
      if !organizations.nil? && !organizations.empty?
        organizations.each do |organization|
          org_name = organization['name'].gsub('\'','')
          org = Organization.where('lower(name) = lower(?)', org_name)[0]
          if org.nil?
            org = Organization.where("aliases @> ARRAY['"+org_name+"']::varchar[]").first
          end
          if org.nil?
            # Create a new organization and assign it as an owner
            org = Organization.new
            org.name = org_name
            org.slug = slug_em(org_name,100)
            org.website = cleanup_url(organization['website'])
            org.save
            org_product = OrganizationsProduct.new
            org_product.org_type = organization['org_type']
            org_product.organization_id = org.id
            org_product.product_id = sync_product.id
            org_product.save!
          else
            org.website = cleanup_url(organization['website'])
            org.name = org_name
            org.save
          end
          if !sync_product.organizations.include?(org)
            puts "  Adding org to product: #{org.name}"
            org_product = OrganizationsProduct.new
            org_product.org_type = organization['org_type']
            org_product.organization_id = org.id
            org_product.product_id = sync_product.id
            org_product.save!
          end
        end
      end
    end

    def sync_giz_project(english_project, german_project, giz_origin)
      # Create sector if it does not exist
      english_sectors = create_or_update_sector(english_project[19], english_project[20], "en", giz_origin)
      german_sectors = create_or_update_sector(german_project[19], german_project[20], "de", giz_origin)

      # Create new project or update existing project
      new_project = Project.where(name: english_project[0]).first || Project.new
      new_project.name = english_project[0].force_encoding('UTF-8')
      new_project.slug = slug_em(english_project[0])
      new_project.origin_id = giz_origin.id
      if !english_project[25].nil?
        new_project.project_url = english_project[25]
      end
      new_project.save!

      # Assign to sectors
      english_sectors.each do |sector_id|
        sector = Sector.find(sector_id)
        if !new_project.sectors.include?(sector)
          new_project.sectors << sector
        end
      end

      german_sectors.each do |sector_id|
        sector = Sector.find(sector_id)
        if !new_project.sectors.include?(sector)
          new_project.sectors << sector
        end
      end

      # Assign tags
      if !english_project[23].nil?
        proj_tags = english_project[23].gsub(/\s*\(.+\)/, '').split(',').map(&:strip)
        proj_tags.each do |proj_tag|
          Tag.where(name: proj_tag,slug: slug_em(proj_tag)).first_or_create
        end
        new_project.tags = proj_tags
      end

      # Assign to SDGs
      if !english_project[24].nil?
        sdg_list = english_project[24].sub("Peace, Justice", "Peace Justice").sub("Reduced Inequality", "Reduced Inequalities").sub("Industry, Innovation, and", "Industry Innovation and")
        sdg_names = sdg_list.split(',')
        sdg_names.each do |sdg_name|
          sdg_slug = slug_em(sdg_name.strip)  
          sdg = SustainableDevelopmentGoal.find_by(slug: sdg_slug)
          if !new_project.sustainable_development_goals.include?(sdg)
            new_project.sustainable_development_goals << sdg
          end
        end
      end

      # Assign to locations
      country_names = english_project[15].split(',')
      country_names.each do |country_name|
        country = Country.find_by(name: country_name.strip)
        if !country.nil?
          if !new_project.countries.include?(country)
            new_project.countries << country
          end
          # Add any German aliases to the country

        end
      end

      # Create both English and German descriptions
      project_desc = ProjectDescription.where(project_id: new_project.id, locale: "en").first || ProjectDescription.new
      project_desc.project_id = new_project.id
      if english_project[2].nil?
        english_project[2] = "No description"
      end
      project_desc.description = english_project[2]
      project_desc.locale = "en"
      project_desc.save!

      project_desc = ProjectDescription.where(project_id: new_project.id, locale: "de").first || ProjectDescription.new
      project_desc.project_id = new_project.id
      if german_project[2].nil?
        german_project[2] = "Kein description"
      end
      project_desc.description = german_project[2]
      project_desc.locale = "de"
      project_desc.save!

      # Create links to Digital Principles
      principles = DigitalPrinciple.all.order(:id)
      for principle_col in 30..38 do
        principle_index = principle_col-30
        if english_project[principle_col] == "1" 
          if !new_project.digital_principles.include?(principles[principle_index])
            new_project.digital_principles << principles[principle_index]
          end
        end
      end

      new_project.save!
    end

    def create_or_update_sector(sector_name, subsectors, locale, giz_origin)
      sector_array = []
      if !sector_name.nil?
        sector_name = sector_name.strip
        sector_slug = slug_em sector_name
        existing_sector = Sector.find_by(slug: sector_slug, origin_id: giz_origin.id)
        if existing_sector.nil?
          new_sector = Sector.new
          new_sector.name = sector_name
          new_sector.slug = sector_slug
          new_sector.origin_id = giz_origin.id
          new_sector.is_displayable = true
          new_sector.locale = locale
          new_sector.save!
          puts "Sector Created: " + sector_name

          existing_sector = Sector.find_by(slug: sector_slug, origin_id: giz_origin.id)
        end

        sector_array << existing_sector.id

        if !subsectors.nil? 
          subsector_array = subsectors.split(',')
          subsector_array.each do |subsector|
            subsector = subsector.strip
            subsector_slug = slug_em subsector
            existing_subsector = Sector.find_by(slug: subsector_slug, parent_sector_id: existing_sector.id, origin_id: giz_origin.id)
            if existing_subsector.nil?
              new_sector = Sector.new
              new_sector.name = sector_name + ": " + subsector
              new_sector.slug = subsector_slug
              new_sector.origin_id = giz_origin.id
              new_sector.is_displayable = true
              new_sector.locale = locale
              new_sector.parent_sector_id = existing_sector.id
              new_sector.save!
              puts "Sub-Sector Created: " + subsector

              sector_array << new_sector.id
            else
              sector_array << existing_subsector.id
            end
          end
        end
      end
      sector_array
    end

    def cleanup_url(maybe_url)
      cleaned_url = ''
      unless maybe_url.blank?
        cleaned_url = maybe_url.strip
                               .sub(/^https?\:\/\//i, '')
                               .sub(/^https?\/\/\:/i, '')
                               .sub(/\/$/, '')
      end
      cleaned_url
    end

    def update_product_description(existing_product, sync_description)
      product_description = ProductDescription.where(product_id: existing_product, locale: I18n.locale)
                                              .first || ProductDescription.new
      product_description.product_id = existing_product.id
      product_description.locale = I18n.locale
      if product_description.description.nil?
        if !sync_description.nil?
          product_description.description = sync_description
        else
          product_descriptions = YAML.load_file('config/product_description.yml')
          product_descriptions['products'].each do |pd|
            if existing_product.slug == pd['slug']
              product_description.description = pd['description']
              puts "Assigning description from yml for: #{existing_product.slug}"
            end
          end
        end
      end

      product_description.save
      puts "Product description updated: #{existing_product.name} -> #{existing_product.slug}."
    end

    def add_latest_product_version(product)
      version_code = 'Latest'
      return if product.product_versions.exists?(version: version_code)

      product_version = ProductVersion.new(version: version_code, version_order: 1)
      product.product_versions << product_version
      if product.save
        puts "Adding 'Latest' as version code for #{product.name}."
      end
    end

    def sync_product_versions(product)
      if product.repository.blank?
        return add_latest_product_version(product)
      end

      puts "Processing: #{product.repository}"
      repo_regex = /(github.com\/)(\S+)\/(\S+)\/?/
      if !(match = product.repository.match(repo_regex))
        return add_latest_product_version(product)
      end

      _, owner, repo = match.captures

      github_uri = URI.parse('https://api.github.com/graphql')
      http = Net::HTTP.new(github_uri.host, github_uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(github_uri.path)
      request.basic_auth(ENV['GITHUB_USERNAME'], ENV['GITHUB_PERSONAL_TOKEN'])
      request.body = { 'query' => graph_ql_request_body(owner, repo, nil) }.to_json

      response = http.request(request)

      response_json = JSON.parse(response.body)
      counter = ProductVersion.where(product_id: product.id).maximum(:version_order)
      if counter.nil?
        counter = 0
      end

      process_current_page(response_json, counter, product)
      process_next_page(response_json, http, request, owner, repo, counter, product)

      if product.save!
        puts "Product versions saved: #{product.product_versions.size}."
      end
    end

    def process_current_page(response_json, counter, product)
      return unless response_json['data'].present? && response_json['data']['repository'].present?

      releases_data = response_json['data']['repository']['releases']['edges']
      if releases_data.empty? && product.product_versions.count.zero?
        return add_latest_product_version(product)
      end

      puts "Processing releases: #{releases_data.count} releases."

      releases_data.each do |release_data|
        version_code = release_data['node']['tagName']
        next if product.product_versions.exists?(version: version_code)

        product_version = ProductVersion.new(version: version_code, version_order: counter += + 1)
        product.product_versions << product_version
      end
    end

    def process_next_page(response_json, http, request, owner, repo, counter, product)
      return unless response_json['data'].present? && response_json['data']['repository'].present?

      releases_info = response_json['data']['repository']['releases']
      return unless releases_info['pageInfo'].present? && releases_info['pageInfo']['hasNextPage'].present?

      offset = releases_info['pageInfo']['endCursor']
      request.body = { 'query' => graph_ql_request_body(owner, repo, offset) }.to_json
      response = http.request(request)

      puts "Processing next page: #{owner}/#{repo} releases with offset: #{offset}."

      response_json = JSON.parse(response.body)

      process_current_page(response_json, counter, product)
      process_next_page(response_json, http, request, owner, repo, counter, product)
    end

    def graph_ql_request_body(owner, repo, offset)
      offset_clause = ') {'
      unless offset.blank?
        offset_clause = ', after:"' + offset + '") {'
      end
      '{'\
      '  repository(name: "' + repo + '", owner: "' + owner + '") {'\
      '    releases(first: 100' + offset_clause + ''\
      '      totalCount'\
      '      pageInfo {'\
      '        endCursor'\
      '        hasNextPage'\
      '      }'\
      '      edges {'\
      '        node {'\
      '          tagName'\
      '        }'\
      '      }'\
      '    }'\
      '  }'\
      '}'
    end

    def sync_license_information(product)
      return if product.repository.blank?

      puts "Processing: #{product.repository}"
      repo_regex = /(github.com\/)(\S+)\/(\S+)\/?/
      return unless (match = product.repository.match(repo_regex))

      _, owner, repo = match.captures

      command = "OCTOKIT_ACCESS_TOKEN=#{ENV['GITHUB_PERSONAL_TOKEN']} licensee detect --remote #{owner}/#{repo}"
      stdout, = Open3.capture3(command)

      return if stdout.blank?

      license_analysis = stdout
      license = stdout.lines.first.split(/\s+/)[1]

      if license != "NOASSERTION"
        product.license_analysis = license_analysis
        product.license = license

        if product.save!
          puts "Product license information saved: #{product.license}."
        end
      end
    end

    def update_tco_data(product)
      return if product.repository.blank?

      # We can't process Gitlab repos currently, so ignore those
      return if product.repository.include?("gitlab")
      return if product.repository.include?("AsTeR")
      
      puts "Processing: #{product.repository}"
      command = "./cloc-git.sh "+product.repository
      stdout, = Open3.capture3(command)

      return if stdout.blank?
     
      code_data = CSV.parse(File.read("./repodata.csv"), headers: true)
      code_data.each do |code_row|
        if code_row['language'] == "SUM"
          puts "NUM LINES: " + code_row['code']
          product.code_lines = code_row['code'].to_i
          
          # COCOMO Calculation is Effort = A * (Lines of Code/1000)^B
          # A and B are based on project complexity. We are using simple, where A=2.4 and B=1.05
          total_klines = (code_row['code'].to_i)/1000
          effort = 2.4 * total_klines**1.05

          product.cocomo = effort.round.to_s
          puts "EFFORT: " + effort.round.to_s
          if product.save!
            puts "Product COCOMO data saved."
          end
        end
      end
    end

    def send_notification
      if !@@product_list.empty?
        admin_users = User.where(receive_backup: true)
        email_body = "New product(s) added by the nightly sync process: <br />#{@@product_list.join('<br />')}."
        admin_users.each do |user|
          cmd = "curl -s --user 'api:#{Rails.application.secrets.mailgun_api_key}'"\
                " https://api.mailgun.net/v3/#{Rails.application.secrets.mailgun_domain}/messages"\
                " -F from='Registry <backups@registry.dial.community>'"\
                " -F to=#{user.email}"\
                " -F subject='Sync task - add product'"\
                " -F html='#{email_body}'"
          puts cmd
          system cmd
        end
        @@product_list.clear
      end
    end

    def sync_product_statistics(product)
      return if product.repository.blank?

      puts "Processing: #{product.repository}"
      repo_regex = /(github.com\/)(\S+)\/(\S+)\/?/
      return unless (match = product.repository.match(repo_regex))

      _, owner, repo = match.captures

      github_uri = URI.parse('https://api.github.com/graphql')
      http = Net::HTTP.new(github_uri.host, github_uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(github_uri.path)
      request.basic_auth(ENV['GITHUB_USERNAME'], ENV['GITHUB_PERSONAL_TOKEN'])
      request.body = { 'query' => graph_ql_statistics(owner, repo) }.to_json

      response = http.request(request)
      product.statistics = JSON.parse(response.body)

      if product.save!
        puts "Product statistics saved: #{product.name}."
      end
    end

    def export_products(source)
      #session = ActionDispatch::Integration::Session.new(Rails.application)
      #session.get "/productlist?source="+source
      server_uri = URI.parse("https://registry.dial.community/productlist?source="+source)
      
      response = Net::HTTP.get(server_uri)
      prod_list = JSON.parse(response)
      prod_list.each do |prod|
        publicgoods_name = prod['publicgoods_name']
        if publicgoods_name.nil?
          publicgoods_name = prod['name']
          puts "NEW PRODUCT: " + publicgoods_name
        end
        if prod['aliases'].nil?
          prod.except!('aliases')
        end
        prod.except!('publicgoods_name')
        puts "SECTOR LIST: " + prod['sectors'].to_s
        prod['name'] = publicgoods_name
        json_string = JSON.pretty_generate prod
        regex = /(?<content>"(?:[^\\"]|\\.)+")|(?<open>\{)\s+(?<close>\})|(?<open>\[)\s+(?<close>\])/m
        json_string = json_string.gsub(regex, '\k<open>\k<content>\k<close>')
        json_string = json_string + "\n"
        File.open("export/"+slug_em(publicgoods_name, 100).gsub("_","-")+".json","w") do |f|
          f.write(json_string)
        end
      end
    end

    def graph_ql_statistics(owner, repo)
      '{'\
      '  repository(name: "' + repo + '", owner: "' + owner + '") {'\
      '    stargazers {'\
      '      totalCount'\
      '    },'\
      '    watchers {'\
      '      totalCount'\
      '    },'\
      '    forkCount,'\
      '    isFork,'\
      '    createdAt,'\
      '    updatedAt,'\
      '    pushedAt,'\
      '    closedPullRequestCount: pullRequests(states: CLOSED) {'\
      '      totalCount'\
      '    },'\
      '    openPullRequestCount: pullRequests(states: OPEN) {'\
      '      totalCount'\
      '    },'\
      '    mergedPullRequestCount: pullRequests(states: MERGED) {'\
      '      totalCount'\
      '    },'\
      '    releases(last: 1) {'\
      '      totalCount,'\
      '      edges {'\
      '        node {'\
      '          name,'\
      '          createdAt,'\
      '          description,'\
      '          url,'\
      '          releaseAssets (last: 1) {'\
      '            edges {'\
      '              node {'\
      '                downloadCount'\
      '              }'\
      '            }'\
      '          }'\
      '        }'\
      '      }'\
      '    }'\
      '  }'\
      '}'\
    end

    def clean_location_data(location, country_lookup, access_token)
      return if !location.country.nil? && !location.city.nil?

      sleep 1

      puts "Processing: #{location.name}."

      uri = URI.parse(Rails.configuration.geocode['esri']['auth_uri'])
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      uri_template = Addressable::Template.new("#{Rails.configuration.geocode['esri']['reverse_geocode_uri']}{?q*}")
      reverse_geocode_uri = uri_template.expand(
        'q': {
          'location': "#{location.points[0].y}, #{location.points[0].x}",
          'langCode': 'en',
          'token': access_token,
          'f': 'json'
        }
      )
      uri = URI.parse(reverse_geocode_uri)
      response = Net::HTTP.post_form(uri, {})
      location_data = JSON.parse(response.body)

      location.city = location_data['address']['City']
      location.state = location_data['address']['Region']
      location.country = country_lookup[location_data['address']['CountryCode']]

      location.name = [location.city, location.state, location.country].reject(&:blank?).join(', ')

      current_slug = slug_em(location.name)
      if Location.where(slug: current_slug).count.positive?
        duplicate_location = Location.slug_starts_with(current_slug).order(slug: :desc).first
        duplicate_count = 1
        if !duplicate_location.nil?
          duplicate_count = duplicate_location.slug
                                              .slice(/_dup\d+$/)
                                              .delete('^0-9')
                                              .to_i + 1
        end
        current_slug = "#{current_slug}_dup#{duplicate_count}"
      end
      location.slug = current_slug

      if location.save
        puts "Updating location with id: #{location.id} to: #{location.name}."
      end
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

    def sync_product_languages(product)
      return if product.repository.blank?

      puts "Processing: #{product.repository}"
      repo_regex = /(github.com\/)(\S+)\/(\S+)\/?/
      return unless (match = product.repository.match(repo_regex))

      _, owner, repo = match.captures

      github_uri = URI.parse('https://api.github.com/graphql')
      http = Net::HTTP.new(github_uri.host, github_uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(github_uri.path)
      request.basic_auth(ENV['GITHUB_USERNAME'], ENV['GITHUB_PERSONAL_TOKEN'])
      request.body = { 'query' => graph_ql_languages(owner, repo) }.to_json

      response = http.request(request)
      product.language_data = JSON.parse(response.body)

      if product.save!
        puts "Product language data saved for: #{product.name}."
      end
    end

    def graph_ql_languages(owner, repo)
      '{'\
      '  repository(name: "' + repo + '", owner: "' + owner + '") {'\
      '    languages(first: 20, orderBy: {field: SIZE, direction: DESC}) {'\
      '      totalCount'\
      '      totalSize'\
      '      edges {'\
      '        size'\
      '        node {'\
      '          name'\
      '          color'\
      '        }'\
      '      }'\
      '    }'\
      '  }'\
      '}'\
    end
  end
end
