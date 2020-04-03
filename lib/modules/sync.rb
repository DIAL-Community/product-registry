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
            assign_sdg_to_product(sdg_obj, existing_product, 'Self-reported')
          end
        end

        if existing_product.save
          update_product_description(existing_product, json_data['description'])
        end
      end
    end

    def sync_public_product(json_data)
      if !json_data['type'].detect { |element| element.downcase == 'software' }.nil?
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
            assign_sdg_to_product(sdg_obj, existing_product, 'Self-reported')
          end
        end

        update_attributes(json_data, existing_product)

        if existing_product.save
          update_product_description(existing_product, json_data['description'])
        end
      end
    end

    def sync_digisquare_product(digi_product)
      digisquare_origin = Origin.find_by(slug: 'digital_square')

      name_aliases = [digi_product['name']]
      digi_product['aliases'] && digi_product['aliases'].each do |name_alias|
        name_aliases.push(name_alias)
      end
      
      existing_product = nil
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
          assign_sdg_to_product(sdg_obj, existing_product, 'Validated')
        end
      end

      if existing_product.save
        update_product_description(existing_product, digi_product['description'])
        puts "Product updated: #{existing_product.name} -> #{existing_product.slug}."
      end
    end

    def sync_osc_product(product)
      puts "Syncing #{product['name']} ..."
      name_aliases = [product['name']]
      product['aliases'] && product['aliases'].each do |name_alias|
        name_aliases.push(name_alias)
      end
      
      sync_product = nil
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
      end

      # This will update website, license, repo URL, organizations, and SDGs
      update_attributes(product, sync_product)

      sdgs = product['SDGs']
      if !sdgs.nil? && !sdgs.empty?
        sdgs.each do |sdg|
          sdg_obj = SustainableDevelopmentGoal.where(number: sdg)[0]
          assign_sdg_to_product(sdg_obj, sync_product, 'Validated')
        end
      end

      maturity = product['maturity']
      if !maturity.nil?
        product_assessment = sync_product.product_assessment
        if product_assessment.nil?
          puts '  Creating new maturity assessment'
          product_assessment = ProductAssessment.new
          product_assessment.product = sync_product
          product_assessment.save
        end
        product_assessment.has_osc = true
        maturity.each do |key, value|
          product_assessment["osc_#{key}"] = value
        end
        product_assessment.save
      end

      osc_origin = Origin.find_by(slug: 'dial_osc')
      if !sync_product.origins.exists?(id: osc_origin.id)
        sync_product.origins.push(osc_origin)
      end

      if sync_product.save
        description = product['description']
        if !description.nil? && !description.empty?
          update_product_description(sync_product, description)
        end
      end
    end

    def assign_sdg_to_product(sdg_obj, product_obj, link_type)
      if !sdg_obj.nil? 
        prod_sdg = ProductsSustainableDevelopmentGoal.where(sustainable_development_goal_id: sdg_obj.id, product_id: product_obj.id)
        if prod_sdg.empty?
          puts "Adding sdg #{sdg_obj.number} to product"
          new_prod_sdg = ProductsSustainableDevelopmentGoal.new
          new_prod_sdg.sustainable_development_goal_id = sdg_obj.id
          new_prod_sdg.product_id = product_obj.id
          new_prod_sdg.link_type = link_type

          new_prod_sdg.save
        elsif prod_sdg.first.link_type.nil?
          product_obj.sustainable_development_goals.delete(sdg_obj)
          new_prod_sdg = ProductsSustainableDevelopmentGoal.new
          new_prod_sdg.sustainable_development_goal_id = sdg_obj.id
          new_prod_sdg.product_id = product_obj.id
          new_prod_sdg.link_type = link_type

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
          org = Organization.where('lower(name) = lower(?)', organization['name'])[0]
          if org.nil?
            org = Organization.where("aliases @> ARRAY['"+organization['name']+"']::varchar[]").first
          end
          if org.nil?
            # Create a new organization and assign it as an owner
            org = Organization.new
            org.name = organization['name']
            org.slug = slug_em(organization['name'])
            org.website = organization['website']
            org.save
            org_product = OrganizationsProduct.new
            org_product.org_type = organization['org_type']
            sync_product.organizations << org
          else
            org.website = cleanup_url(organization['website'])
            org.save
          end
          if !sync_product.organizations.include?(org)
            puts "  Adding org to product: #{org.name}"
            org_product = OrganizationsProduct.new
            org_product.org_type = organization['org_type']
            sync_product.organizations << org
          end
        end
      end
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
      if !sync_description.nil?
        product_description.description = JSON.generate('ops': [{ 'insert': sync_description }])
      elsif product_description.description.nil?
        product_descriptions = YAML.load_file('config/product_description.yml')
        product_descriptions['products'].each do |pd|
          if existing_product.slug == pd['slug']
            product_description.description = pd['description']
            puts "Assigning description from yml for: #{existing_product.slug}"
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

    def send_notification
      if !@@product_list.empty?
        admin_users = User.where(role: 'admin')
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
  end
end
