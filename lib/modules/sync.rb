require 'modules/slugger'
include Modules::Slugger

module Modules
  module Sync
    def sync_unicef_product(json_data)

      if json_data['type'].detect{ |element| element.downcase == 'software' } != nil
        unicef_origin = Origin.find_by(:slug => 'unicef')
        name_aliases = [json_data['name'], json_data['initialism']].reject{ |x| x.nil? || x.empty? }

        blacklist = YAML.load_file("config/product_blacklist.yml")
        blacklist.each do |blacklist_item|
          if json_data['name'] == blacklist_item['item']
            puts "Skipping #{json_data['name']}"
            return
          end
        end
        existing_product = nil
        name_aliases.each do |name_alias|
          # Find by name, and then by aliases and then by slug.
          if existing_product.nil?
            slug = slug_em name_alias
            existing_product = Product.first_duplicate(name_alias, slug)
          else
            break
          end
        end

        website = cleanup_url(json_data['website'])
        repository = cleanup_url(json_data['repo_main'])

        if existing_product.nil?
          existing_product = Product.new
          existing_product.name = name_aliases.first
          existing_product.slug = slug_em existing_product.name
        end

        existing_product.website = website
        existing_product.repository = repository

        # Assign what's left in the alias array as aliases.
        existing_product.aliases.concat(name_aliases.reject{ |x| x == existing_product.name }).uniq!

        # Set the origin to be 'unicef'
        if (!existing_product.origins.exists?(:id => unicef_origin.id))
          existing_product.origins.push(unicef_origin)
        end

        sdgs = json_data['SDGs']
        if !sdgs.nil? && !sdgs.empty?
          sdgs.each do |sdg|
            sdg_obj = SustainableDevelopmentGoal.find_by(number: sdg)
            if !sdg_obj.nil? && !existing_product.sustainable_development_goals.include?(sdg_obj)
              puts "Adding sdg #{sdg} to product"
              existing_product.sustainable_development_goals << sdg_obj
            end
          end
        end

        if existing_product.save
          update_product_description(existing_product, json_data['description'])
        end
      end
    end

    def sync_digisquare_product(section)
      puts section
      digisquare_origin = Origin.find_by(:slug => 'digital_square')

      candidate_name = section['line']
      blacklist = YAML.load_file("config/product_blacklist.yml")
      blacklist.each do |blacklist_item|
        if candidate_name == blacklist_item['item']
          puts "skipping #{candidate_name}"
          return
        end
      end
      candidate_slug = slug_em(candidate_name)
      existing_product = Product.first_duplicate(candidate_name, candidate_slug)
      if existing_product.nil?
        existing_product = Product.new
        existing_product.name = candidate_name
        existing_product.slug = candidate_slug
      end

      if (!existing_product.origins.exists?(id: digisquare_origin.id))
        existing_product.origins.push(digisquare_origin)
      end

      if existing_product.save
        update_product_description(existing_product, nil)
        puts "Product updated: #{existing_product.name} -> #{existing_product.slug}."
      end
    end

    def sync_osc_product(product)
      puts "Syncing #{product['name']} ..."
      product_name = product['name']
      slug = slug_em product_name
      sync_product = Product.first_duplicate(product_name, slug)
      if sync_product.nil?
        sync_product = Product.new
        sync_product.name = product_name
        sync_product.slug = slug
        if sync_product.save
          puts "  Added new product: #{sync_product.name} -> #{sync_product.slug}"
        end
      end

      website = product['website']
      if !website.nil? && !website.empty?
        puts "  Updating website: #{sync_product.website} => #{website}"
        sync_product.website = website
      end

      organizations = product['organizations']
      if !organizations.nil? && !organizations.empty?
        organizations.each do |organization|
          org = Organization.where('lower(name) = lower(?)', organization)[0]
          if !org.nil? && !sync_product.organizations.include?(org)
            puts "  Adding org to product: #{org.name}"
            sync_product.organizations << org
          end
        end
      end

      sdgs = product['SDGs']
      if !sdgs.nil? && !sdgs.empty?
        sdgs.each do |sdg|
          sdg_obj = SustainableDevelopmentGoal.where(number: sdg)[0]
          if !sdg_obj.nil? && !sync_product.sustainable_development_goals.include?(sdg_obj)
            puts "  Adding sdg #{sdg} to product"
            sync_product.sustainable_development_goals << sdg_obj
          end
        end
      end

      maturity = product['maturity']
      if !maturity.nil?
        product_assessment = sync_product.product_assessment
        if product_assessment.nil?
          puts "  Creating new maturity assessment"
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

      osc_origin = Origin.find_by(:slug => 'dial_osc')
      if (!sync_product.origins.exists?(:id => osc_origin.id))
        sync_product.origins.push(osc_origin)
      end

      if sync_product.save
        update_product_description(sync_product, nil)
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

    def sync_product_versions(product)
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
      request.body = { 'query' => graph_ql_request_body(owner, repo, nil) }.to_json

      response = http.request(request)

      response_json = JSON.parse(response.body)
      counter = ProductVersion.where(product_id: product.id).maximum(:version_order)
      if counter.nil?
        counter = 0
      end

      process_current_page(response_json, counter, product)
      process_next_page(response_json, http, request, owner, repo)

      if product.save!
        puts "Product versions saved: #{product.product_versions.size}."
      end
    end

    def process_current_page(response_json, counter, product)
      return unless response_json['data'].present? && response_json['data']['releases'].present?
      releases_data = response_json['data']['repository']['releases']['edges']
      return if releases_data.empty?

      releases_data.each do |release_data|
        version_code = release_data['node']['tagName']
        next if product.product_versions.exists?(version: version_code)

        product_version = ProductVersion.new(version: version_code, version_order: counter += + 1)
        product.product_versions << product_version
      end
    end

    def process_next_page(response_json, http, request, owner, repo)
      return unless response_json['data'].present? && response_json['data']['repository'].present?
      releases_info = response_json['data']['repository']['releases']
      return unless releases_info['pageInfo'].present? && releases_info['pageInfo']['hasNextPage']

      offset = releases_info['pageInfo']['endCursor']
      request.body = { 'query' => graph_ql_request_body(owner, repo, offset) }.to_json
      response = http.request(request)

      response_json = JSON.parse(response.body)

      process_current_page(response_json)
      process_next_page(response_json, http, request, owner, repo)
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

      product.license_analysis = license_analysis
      product.license = license

      if product.save!
        puts "Product license information saved: #{product.license}."
      end
    end
  end
end
