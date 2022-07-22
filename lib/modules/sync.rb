# frozen_string_literal: true
# rubocop:disable Metrics/BlockNesting
# rubocop:disable Style/ClassVars

# TODO: Revisit this module to reduce the if nesting.
# Disabling because of this rubocop issue:
# - Avoid more than 3 levels of block nesting. (convention:Metrics/BlockNesting)
# - Replace class var @@product_list with a class instance var. (convention:Style/ClassVars)

require 'resolv-replace'
require 'modules/slugger'
include Modules::Slugger

module Modules
  module Sync
    @@product_list = []
    @@dataset_list = []

    def sync_public_dataset(json_data)
      unless json_data['type'].detect { |element| element.downcase != 'software' }.nil?
        puts "Syncing open data: #{json_data['name']}."
        dpga_origin = Origin.find_by(slug: 'dpga')

        name_aliases = [json_data['name']]
        json_data['aliases']&.each do |curr_alias|
          name_aliases << curr_alias if curr_alias != ''
        end

        existing_dataset = nil
        name_aliases.each do |name_alias|
          # Find by name, and then by aliases and then by slug.
          break unless existing_dataset.nil?

          slug = slug_em(name_alias)
          existing_dataset = Dataset.first_duplicate(name_alias, slug)
          # Check to see if both just have the same alias. In this case, it's not a duplicate
        end

        is_new = false
        if existing_dataset.nil?
          # Mark this dataset as new one. This means we will use this import as the baseline of the data.
          is_new = true

          existing_dataset = Dataset.new
          existing_dataset.name = name_aliases.first
          existing_dataset.slug = slug_em(existing_dataset.name)
          @@dataset_list << existing_dataset.name
        end

        website = cleanup_url(json_data['website'])
        if !website.nil? && !website.empty?
          existing_dataset.website = website
        end

        existing_dataset.dataset_type = 'ai_model' unless json_data['type'].detect { |e| e.downcase == 'aimodel' }.nil?
        existing_dataset.dataset_type = 'content' unless json_data['type'].detect { |e| e.downcase == 'data' }.nil?
        existing_dataset.dataset_type = 'content' unless json_data['type'].detect { |e| e.downcase == 'content' }.nil?
        existing_dataset.dataset_type = 'standard' unless json_data['type'].detect { |e| e.downcase == 'standard' }.nil?
        existing_dataset.dataset_type = 'dataset' unless existing_dataset.dataset_type

        # Assign what's left in the alias array as aliases.
        existing_dataset.aliases.concat(name_aliases.reject { |x| x == existing_dataset.name }).uniq!

        existing_dataset.license = json_data['license'][0]['spdx'] unless json_data['license'].nil?

        # Set the origin to be 'DPGA'
        if !dpga_origin.nil? && !existing_dataset.origins.exists?(id: dpga_origin.id)
          existing_dataset.origins.push(dpga_origin)
        end

        sectors = json_data['sectors']
        if !sectors.nil? && !sectors.empty?
          sectors.each do |sector|
            get_sector(sector, nil, 'en')
            sector_obj = Sector.find_by(name: sector)

            # Check to see if the sector exists already
            if !sector_obj.nil? && !existing_dataset.sectors.include?(sector_obj)
              puts "  Adding sector #{sector_obj.name} to dataset."
              existing_dataset.sectors << sector_obj
            else
              puts "  Unable to find sector: #{sector}."
            end
          end
        end

        sdg_entries = json_data['SDGs']
        if !sdg_entries.nil? && !sdg_entries.empty?
          sdg_entries.each do |sdg_entry|
            sdg_obj = SustainableDevelopmentGoal.find_by(number: sdg_entry['SDGNumber'])
            next if sdg_obj.nil?

            unless existing_dataset.id.nil?
              dataset_sdg = DatasetSustainableDevelopmentGoal.find_by(
                dataset_id: existing_dataset.id,
                sustainable_development_goal_id: sdg_obj.id
              )
              next unless dataset_sdg.nil?
            end

            dataset_sdg = DatasetSustainableDevelopmentGoal.new
            dataset_sdg.sustainable_development_goal_id = sdg_obj.id
            dataset_sdg.mapping_status = DatasetSustainableDevelopmentGoal.mapping_status_types[:VALIDATED]

            existing_dataset.dataset_sustainable_development_goals << dataset_sdg
          end
        end

        organization_entries = json_data['organizations']
        if !organization_entries.nil? && !organization_entries.empty?
          organization_entries.each do |organization_entry|
            organization = Organization.find_by(name: organization_entry['name'])
            next if organization.nil?

            unless is_new
              organization_dataset = OrganizationsDataset.find_by(
                dataset_id: existing_dataset.id,
                organization_id: organization.id,
                organization_type: organization_entry['org_type']
              )
              next unless organization_dataset.nil?
            end

            organization_dataset = OrganizationsDataset.new
            organization_dataset.organization_id = organization.id
            organization_dataset.organization_type = organization_entry['org_type']

            existing_dataset.organizations_datasets << organization_dataset
          end
        end

        if existing_dataset.save!
          puts "Dataset #{existing_dataset.name} saved."

          # Moving descriptions from product to dataset's description table.
          existing_dataset_description = DatasetDescription.new
          existing_dataset_description.description = json_data['description']
          existing_dataset_description.locale = 'en'
          existing_dataset_description.dataset = existing_dataset

          if (is_new || !existing_dataset.manual_update) && existing_dataset_description.save!
            puts "  Adding description for locale: #{existing_dataset_description.locale}."
          end
          puts "--"
        end
      end
    end

    def sync_public_product(json_data)
      unless json_data['type'].detect { |element| element.downcase == 'software' }.nil?
        puts "Syncing product: #{json_data['name']}."

        dpga_origin = Origin.find_by(slug: 'dpga')
        dpga_endorser = Endorser.find_by(slug: 'dpga')
        name_aliases = [json_data['name']]
        json_data['aliases']&.each do |curr_alias|
          name_aliases << curr_alias if curr_alias != ''
        end

        existing_product = nil
        name_aliases.each do |name_alias|
          # Find by name, and then by aliases and then by slug.
          break unless existing_product.nil?

          slug = slug_em(name_alias)
          existing_product = Product.first_duplicate(name_alias, slug)
          # Check to see if both just have the same alias. In this case, it's not a duplicate
        end

        if existing_product.nil?
          # Check to see if it is a child product (ie. it already has a repository)
          product_repository = ProductRepository.find_by(slug: slug_em("#{json_data['name']} Repository"))
          return unless product_repository.nil?

          existing_product = Product.new
          existing_product.name = name_aliases.first
          existing_product.slug = slug_em(existing_product.name)
          @@product_list << existing_product.name
        end

        # Assign what's left in the alias array as aliases.
        existing_product.aliases.concat(name_aliases.reject { |x| x == existing_product.name }).uniq!

        # Set the origin to be 'DPGA'
        if !dpga_origin.nil? && !existing_product.origins.exists?(id: dpga_origin.id)
          existing_product.origins.push(dpga_origin)
        end

        sdgs = json_data['SDGs']
        if !sdgs.nil? && !sdgs.empty?
          sdgs.each do |sdg|
            sdg_obj = SustainableDevelopmentGoal.find_by(number: sdg['SDGNumber'])
            assign_sdg_to_product(sdg_obj, existing_product,
                                  ProductSustainableDevelopmentGoal.mapping_status_types[:SELF_REPORTED])
          end
        end

        sectors = json_data['sectors']
        if !sectors.nil? && !sectors.empty?
          sectors.each do |sector|
            get_sector(sector, nil, 'en')
            sector_obj = Sector.find_by(name: sector)

            # Check to see if the sector exists already
            if !sector_obj.nil? && !existing_product.sectors.include?(sector_obj)
              puts "  Adding sector #{sector_obj.name} to product"
              existing_product.sectors << sector_obj
            else
              puts "  Unable to find sector: #{sector}"
            end
          end
        end

        existing_product.product_type = 'dataset' if json_data['type'][0].downcase == 'data'

        # Update specific information that we need to save for later syncing
        # existing_product.publicgoods_data["name"] = json_data["name"]
        # existing_product.publicgoods_data["aliases"] = json_data["aliases"]
        # existing_product.publicgoods_data["stage"] = json_data["stage"]

        if json_data['stage'] == 'DPG' && !existing_product.endorsers.include?(dpga_endorser)
          existing_product.endorsers << dpga_endorser
        end

        existing_product.save!
        update_attributes(json_data, existing_product)
        existing_product.save!

        update_product_description(existing_product, json_data['description']) unless existing_product.manual_update
      end
      existing_product
    end

    def sync_digisquare_product(digi_product, digisquare_maturity)
      digisquare_origin = Origin.find_by(slug: 'digital_square')
      dsq_endorser = Endorser.find_by(slug: 'dsq')

      name_aliases = [digi_product['name']]
      digi_product['aliases']&.each do |name_alias|
        name_aliases.push(name_alias)
      end

      existing_product = nil
      is_new = false
      name_aliases.each do |name_alias|
        # Find by name, and then by aliases and then by slug.
        break unless existing_product.nil?

        slug = slug_em(name_alias)
        existing_product = Product.first_duplicate(name_alias, slug)
      end

      if existing_product.nil?
        existing_product = Product.new
        existing_product.name = digi_product['name']
        existing_product.slug = slug_em(digi_product['name'])
        existing_product.save
        @@product_list << existing_product.name
        is_new = true
      end

      existing_product.origins.push(digisquare_origin) unless existing_product.origins.exists?(id: digisquare_origin.id)

      existing_product.save
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
        next if existing_product.name != ds_maturity['name']

        # Get the legacy rubric
        maturity_rubric = MaturityRubric.find_by(slug: 'legacy_rubric')
        next if maturity_rubric.nil?

        ds_maturity['maturity'].each do |key, value|
          # Find the correct category and indicator
          categories = RubricCategory.where(maturity_rubric_id: maturity_rubric.id).map(&:id)
          category_indicator = CategoryIndicator.find_by(rubric_category: categories, name: key)
          # Save the value in ProductIndicators
          product_indicator = ProductIndicator.where(product_id: existing_product.id,
                                                     category_indicator_id: category_indicator.id)
                                              .first || ProductIndicator.new
          product_indicator.product_id = existing_product.id
          product_indicator.category_indicator_id = category_indicator.id
          product_indicator.indicator_value = value
          product_indicator.save!
        end
      end

      existing_product.endorsers << dsq_endorser unless existing_product.endorsers.include?(dsq_endorser)

      existing_product.save
      if is_new || !existing_product.manual_update
        update_product_description(existing_product, digi_product['description'])
      end
      puts "Product updated: #{existing_product.name} -> #{existing_product.slug}."
      puts "--"
      existing_product
    end

    def sync_osc_product(product)
      puts "Syncing #{product['name']} ..."
      name_aliases = [product['name']]
      product['aliases']&.each do |name_alias|
        name_aliases.push(name_alias)
      end

      sync_product = nil
      is_new = false
      name_aliases.each do |name_alias|
        # Find by name, and then by aliases and then by slug.
        break unless sync_product.nil?

        slug = slug_em(name_alias)
        sync_product = Product.first_duplicate(name_alias, slug)
      end
      if sync_product.nil?
        sync_product = Product.new
        sync_product.name = product['name']
        sync_product.slug = slug_em(product['name'])
        puts "  Added new product: #{sync_product.name} -> #{sync_product.slug}" if sync_product.save
        @@product_list << sync_product.name
      end

      if sync_product.nil?
        sync_product = Product.new
        sync_product.name = name_aliases.first
        sync_product.slug = slug_em(existing_product.name)
        @@product_list << existing_product.name
        is_new = true
      end

      if !product['type'].nil? && !product['type'].detect { |element| element.downcase == 'data' }.nil?
        sync_product.product_type = 'dataset'
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
      unless maturity.nil?
        # Get the legacy rubric
        maturity_rubric = MaturityRubric.find_by(slug: 'legacy_rubric')
        unless maturity_rubric.nil?
          maturity.each do |key, value|
            # Find the correct category and indicator
            categories = RubricCategory.where(maturity_rubric_id: maturity_rubric.id).map(&:id)
            category_indicator = CategoryIndicator.find_by(rubric_category: categories, slug: key)
            # Save the value in ProductIndicators
            product_indicator = ProductIndicator.where(product_id: sync_product.id,
                                                       category_indicator_id: category_indicator.id)
                                                .first || ProductIndicator.new
            product_indicator.product_id = sync_product.id
            product_indicator.category_indicator_id = category_indicator.id
            product_indicator.indicator_value = value
            product_indicator.save!
          end
        end
      end

      osc_origin = Origin.find_by(slug: 'dial_osc')
      sync_product.origins.push(osc_origin) unless sync_product.origins.exists?(id: osc_origin.id)

      sync_product.save
      if is_new || !sync_product.manual_update
        description = product['description']
        update_product_description(sync_product, description) if !description.nil? && !description.empty?
      end
      sync_product
    end

    def assign_sdg_to_product(sdg_obj, product_obj, mapping_status)
      unless sdg_obj.nil?
        prod_sdg = ProductSustainableDevelopmentGoal.where(sustainable_development_goal_id: sdg_obj.id,
                                                           product_id: product_obj.id)
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

    def search_in_ignorelist(json_data, ignore_list)
      ignore_list.each do |ignored|
        if json_data['name'] == ignored['item']
          puts "Skipping #{json_data['name']}"
          return 'Skipped product data.'
        end
      end
      false
    end

    def update_repository_data(product_data, product)
      # Skip if product is nil.
      return if product.nil?

      if !product_data['type'].nil? && !product_data['type'].detect { |element| element.downcase == 'software' }.nil?
        prod_name = product_data['name']
        prod_name = product.name unless product.nil?

        # This section is used for Digi Square and OSC sync
        repository = product_data['repositoryURL']
        if !repository.nil? && !repository.empty?
          product_repository = ProductRepository.find_by(slug: slug_em("#{prod_name} Repository"))
          return if !product_repository.nil? && product_repository.product.manual_update

          if product_repository.nil?
            puts "  Creating repository for: #{prod_name} => #{repository}."
            repository_attrs = {
              name: "#{prod_name} Repository",
              absolute_url: repository.to_s,
              description: "Main code repository of #{prod_name}.",
              main_repository: true
            }
            repository_attrs[:product] = product
            repository_attrs[:slug] = slug_em(repository_attrs[:name])
            product_repository = ProductRepository.create!(repository_attrs)
          else
            puts "  Updating repository for: #{product_repository.name} => #{repository}."
            product_repository.absolute_url = repository
            license = product_data['license']
            if !license.nil? && !license.empty?
              puts "  Updating license for: #{product_repository.name} => #{license}."
              if !license.is_a?(Array)
                product_repository.license = license
              else
                product_repository.license = license.first['spdx']
                product_repository.dpga_data['licenseURL'] = license.first['licenseURL']
              end
            end
          end
          product_repository.save!
        end

        # DPGA now lists multiple repositories
        repositories = product_data['repositories']
        repositories&.each do |curr_repo|
          repo_name = "#{prod_name} #{curr_repo['name']}"
          product_repository = ProductRepository.find_by(slug: slug_em(repo_name)) ||
            ProductRepository.find_by(slug: slug_em("#{prod_name} Repository"))
          if product_repository.nil?
            puts "  Creating repository for: #{repo_name} "
            repository_attrs = {
              name: repo_name.to_s,
              slug: slug_em(repo_name).to_s,
              absolute_url: (curr_repo['url']).to_s,
              description: "Main code repository of #{prod_name}.",
              main_repository: true
            }
            repository_attrs[:product] = product
            product_repository = ProductRepository.create!(repository_attrs)
          else
            puts "  Updating repository for: #{repo_name} "
            product_repository.absolute_url = curr_repo['url']
            if !license.nil? && !license.empty?
              puts "  Updating license for: #{product_repository.name} => #{license}."
              if !license.is_a?(Array)
                product_repository.license = license
              else
                product_repository.license = license.first['spdx']
                product_repository.dpga_data['licenseURL'] = license.first['licenseURL']
              end
            end
          end
          product_repository.save!
        end
      end
    end

    def update_attributes(product, sync_product)
      website = cleanup_url(product['website'])
      if !website.nil? && !website.empty?
        puts "  Updating website: #{sync_product.website} => #{website}"
        sync_product.website = website
      end

      organizations = product['organizations']
      if !organizations.nil? && !organizations.empty?
        organizations.each do |organization|
          org_name = organization['name'].gsub('\'', '')
          org = Organization.where('lower(name) = lower(?) or slug = ?', org_name, slug_em(org_name))[0]
          org = Organization.where("aliases @> ARRAY['#{org_name}']::varchar[]").first if org.nil?
          if org.nil?
            # Create a new organization and assign it as an owner
            org = Organization.new
            org.name = org_name
            org.slug = slug_em(org_name, 100)
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
          next if sync_product.organizations.include?(org)

          puts "  Adding org to product: #{org.name}"
          org_product = OrganizationsProduct.new
          org_product.org_type = organization['org_type']
          org_product.organization_id = org.id
          org_product.product_id = sync_product.id
          org_product.save!
        end
      end
    end

    def sync_giz_project(english_project, german_project, giz_origin)
      # Create sector if it does not exist
      english_sectors = get_sector(english_project[19], english_project[20], 'en')
      # german_sectors = get_sector(german_project[19], german_project[20], "de")
      german_sectors = []

      # Create new project or update existing project
      project_slug = slug_em(english_project[0], 64)
      new_project = Project.where(slug: project_slug).first || Project.new
      new_project.name = english_project[0].force_encoding('UTF-8')
      new_project.slug = project_slug
      new_project.origin_id = giz_origin.id
      unless english_project[11].nil?
        begin
          new_project.start_date = Date.strptime(english_project[11], '%m/%Y')
        rescue StandardError
          puts "Unable to parse project start date."
        end
      end
      unless english_project[12].nil?
        begin
          new_project.end_date = Date.strptime(english_project[12], '%m/%Y')
        rescue StandardError
          puts "Unable to parse project end date."
        end
      end
      new_project.project_url = english_project[25] unless english_project[25].nil?
      new_project.save!

      # Assign implementing organization
      implementer_org = Organization.name_contains(english_project[5])

      if !implementer_org.empty? && !new_project.organizations.include?(implementer_org[0])
        proj_org = ProjectsOrganization.new
        proj_org.org_type = 'implementer'
        proj_org.project_id = new_project.id
        proj_org.organization_id = implementer_org[0].id
        proj_org.save!
      end

      # Clear sectors
      new_project.sectors = []

      # Assign to sectors
      english_sectors.each do |sector_id|
        sector = Sector.find(sector_id)
        new_project.sectors << sector unless new_project.sectors.include?(sector)
      end

      german_sectors.each do |sector_id|
        sector = Sector.find(sector_id)
        new_project.sectors << sector unless new_project.sectors.include?(sector)
      end

      # Assign tags
      unless english_project[23].nil?
        add_tags = []
        proj_tags = english_project[23].gsub(/\s*\(.+\)/, '').split(',').map(&:strip)
        proj_tags.each do |proj_tag|
          new_tag = Tag.where(name: proj_tag, slug: slug_em(proj_tag)).first
          unless new_tag.nil?
            add_tags << new_tag
          end
        end
        new_project.tags = add_tags
      end

      # Assign to SDGs
      unless english_project[24].nil?
        sdg_list = english_project[24].sub('Peace, Justice', 'Peace Justice')
                                      .sub('Reduced Inequality', 'Reduced Inequalities')
                                      .sub('Industry, Innovation, and', 'Industry Innovation and')
        sdg_names = sdg_list.split(',')
        sdg_names.each do |sdg_name|
          sdg_slug = slug_em(sdg_name.strip)
          sdg = SustainableDevelopmentGoal.find_by(slug: sdg_slug)
          unless new_project.sustainable_development_goals.include?(sdg)
            new_project.sustainable_development_goals << sdg
          end
        end
      end

      # Assign to locations
      country_names = !english_project[14].nil? && english_project[14].split(',')
      country_names.each do |country_name|
        country = Country.find_by(name: country_name.strip)
        next if country.nil?

        new_project.countries << country unless new_project.countries.include?(country)
        # Add any German aliases to the country
      end

      # Create both English and German descriptions
      project_desc = ProjectDescription.where(project_id: new_project.id, locale: 'en').first || ProjectDescription.new
      project_desc.project_id = new_project.id
      english_project[2] = 'No description' if english_project[2].nil?
      project_desc.description = english_project[2]
      project_desc.locale = 'en'
      project_desc.save!

      project_desc = ProjectDescription.where(project_id: new_project.id, locale: 'de').first || ProjectDescription.new
      project_desc.project_id = new_project.id
      german_project[2] = 'Kein description' if german_project[2].nil?
      project_desc.description = german_project[2]
      project_desc.locale = 'de'
      project_desc.save!

      # Create links to Digital Principles
      principles = DigitalPrinciple.all.order(:id)
      (52..60).each do |principle_col|
        principle_index = principle_col - 52
        next unless english_project[principle_col] == '1'

        unless new_project.digital_principles.include?(principles[principle_index])
          new_project.digital_principles << principles[principle_index]
        end
      end

      new_project.save!
    end

    def get_sector(sector_name, subsectors, locale)
      sector_map = File.read('utils/sector_map.json')
      sector_json = JSON.parse(sector_map)

      sector_array = []
      unless sector_name.nil?
        sector_name = sector_name.strip
        sector_slug = slug_em(sector_name)
        existing_sector = Sector.where(
          'slug like ? and locale = ? and is_displayable is true and parent_sector_id is null',
          "%#{sector_slug}%", locale
        ).first
        if existing_sector.nil?
          puts '  Sector slug: ' + sector_slug
          puts '  Lookup: ' + sector_json[sector_slug].to_s
          if !sector_json[sector_slug].nil?
            existing_sector = Sector.where(
              'slug like ? and locale = ? and is_displayable is true', "%#{sector_json[sector_slug]}%", locale
            ).first
            sector_array << existing_sector.id unless existing_sector.nil?
          else
            puts "  Add sector to map: #{sector_slug}"
          end
        else
          sector_array << existing_sector.id
        end

        unless subsectors.nil?
          subsector_array = subsectors.split(',')
          subsector_array.each do |subsector|
            subsector = subsector.strip
            subsector_slug = slug_em(subsector, 64)
            existing_subsector = Sector.where(
              'slug like ? and parent_sector_id = ? and locale = ? and is_displayable is true',
              "%#{subsector_slug}%", existing_sector.id, locale
            ).first
            if existing_subsector.nil?
              if !sector_json[subsector_slug].nil?
                existing_subsector = Sector.where(
                  'slug like ? and parent_sector_id = ? and locale = ? and is_displayable is true',
                  "%#{sector_json[subsector_slug]}%", existing_sector.id, locale
                ).first
                sector_array << existing_subsector.id unless existing_subsector.nil?
              else
                puts "  Add sector to map: #{subsector_slug}"
              end
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
                               .sub(/^https?:\/\//i, '')
                               .sub(/^https?\/\/:/i, '')
                               .sub(/\/$/, '')
      end
      cleaned_url
    end

    def update_product_description(existing_product, sync_description)
      product_description = ProductDescription.where(product_id: existing_product, locale: I18n.locale)
                                              .first || ProductDescription.new
      product_description.product_id = existing_product.id
      product_description.locale = I18n.locale
      if product_description.description.nil? || product_description.description == ''
        if !sync_description.nil?
          product_description.description = sync_description
        else
          product_descriptions = YAML.load_file('config/product_description.yml')
          product_descriptions['products'].each do |pd|
            if existing_product.slug == pd['slug']
              product_description.description = pd['description']
              puts "  Assigning description from yml for: #{existing_product.slug}"
            end
          end
        end
      end

      product_description.save
      puts "  Product description updated: #{existing_product.name} -> #{existing_product.slug}."
    end

    def sync_license_information(product_repository)
      return if product_repository.absolute_url.blank?

      puts "Processing: #{product_repository.absolute_url}"
      repo_regex = /(github.com\/)(\S+)\/(\S+)\/?/
      return unless (match = product_repository.absolute_url.match(repo_regex))

      _, owner, repo = match.captures

      command = "OCTOKIT_ACCESS_TOKEN=#{ENV['GITHUB_PERSONAL_TOKEN']} licensee detect --remote #{owner}/#{repo}"
      stdout, = Open3.capture3(command)

      return if stdout.blank?

      license_data = stdout
      license = stdout.lines.first.split(/\s+/)[1]

      if license != 'NOASSERTION'
        product_repository.license_data = license_data
        product_repository.license = license

        puts "Repository license data for #{product_repository.name} saved." if product_repository.save!
      end
    end

    def update_tco_data(product_repository)
      return if product_repository.absolute_url.blank?

      # We can't process Gitlab repos currently, so ignore those
      return if product_repository.absolute_url.include?('gitlab')
      return if product_repository.absolute_url.include?('AsTeR')

      puts "Processing: #{product_repository.absolute_url}"
      command = "./cloc-git.sh #{product_repository.absolute_url}"
      stdout, = Open3.capture3(command)

      return if stdout.blank?

      code_data = CSV.parse(File.read('./repodata.csv'), headers: true)
      code_data.each do |code_row|
        next unless code_row['language'] == 'SUM'

        puts "Number of lines : #{code_row['code']}"
        product_repository.code_lines = code_row['code'].to_i

        # COCOMO Calculation is Effort = A * (Lines of Code/1000)^B
        # A and B are based on project complexity. We are using simple, where A=2.4 and B=1.05
        total_klines = code_row['code'].to_i / 1000
        effort = 2.4 * total_klines**1.05

        product_repository.cocomo = effort.round.to_s
        puts "Product effort: #{effort.round}."
        puts "Product repository #{product_repository.name} COCOMO data saved." if product_repository.save!
      end
    end

    def send_notification
      unless @@product_list.empty?
        admin_users = User.where(receive_backup: true)
        email_body = "New product(s) added by the nightly sync process: <br />#{@@product_list.join('<br />')}."
        admin_users.each do |user|
          RakeMailer.sync_product_added(user.email, email_body).deliver_now
        end
        @@product_list.clear
      end
    end

    def sync_product_statistics(product_repository)
      return if product_repository.absolute_url.blank?

      puts "Processing: #{product_repository.absolute_url}"
      repo_regex = /(github.com\/)(\S+)\/(\S+)\/?/
      return unless (match = product_repository.absolute_url.match(repo_regex))

      _, owner, repo = match.captures

      github_uri = URI.parse('https://api.github.com/graphql')
      http = Net::HTTP.new(github_uri.host, github_uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(github_uri.path)
      request.basic_auth(ENV['GITHUB_USERNAME'], ENV['GITHUB_PERSONAL_TOKEN'])
      request.body = { 'query' => graph_ql_statistics(owner, repo) }.to_json

      response = http.request(request)
      product_repository.statistical_data = JSON.parse(response.body)

      puts "Repository statistical data for #{product_repository.name} saved." if product_repository.save!
    end

    def export_products(source)
      # session = ActionDispatch::Integration::Session.new(Rails.application)
      # session.get "/productlist?source="+source
      server_uri = URI.parse("https://solutions.dial.community/productlist?source=#{source}")

      response = Net::HTTP.get(server_uri)
      prod_list = JSON.parse(response)
      prod_list.each do |prod|
        publicgoods_name = prod['publicgoods_name']
        if publicgoods_name.nil?
          publicgoods_name = prod['name']
          puts "NEW PRODUCT: #{publicgoods_name}"
        end
        prod.except!('aliases') if prod['aliases'].nil?
        prod.except!('publicgoods_name')
        puts "SECTOR LIST: #{prod['sectors']}"
        prod['name'] = publicgoods_name
        json_string = JSON.pretty_generate(prod)
        regex = /(?<content>"(?:[^\\"]|\\.)+")|(?<open>\{)\s+(?<close>\})|(?<open>\[)\s+(?<close>\])/m
        json_string = json_string.gsub(regex, '\k<open>\k<content>\k<close>')
        json_string += "\n"
        File.open("export/#{slug_em(publicgoods_name, 100).gsub('_', '-')}.json", 'w') do |f|
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

    def sync_product_languages(product_repository)
      return if product_repository.absolute_url.blank?

      puts "Processing: #{product_repository.absolute_url}"
      repo_regex = /(github.com\/)(\S+)\/(\S+)\/?/
      return unless (match = product_repository.absolute_url.match(repo_regex))

      _, owner, repo = match.captures

      github_uri = URI.parse('https://api.github.com/graphql')
      http = Net::HTTP.new(github_uri.host, github_uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(github_uri.path)
      request.basic_auth(ENV['GITHUB_USERNAME'], ENV['GITHUB_PERSONAL_TOKEN'])
      request.body = { 'query' => graph_ql_languages(owner, repo) }.to_json

      response = http.request(request)
      product_repository.language_data = JSON.parse(response.body)

      puts "Repository language data for '#{product_repository.name}' saved." if product_repository.save!
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
# rubocop:enable Style/ClassVars
# rubocop:enable Metrics/BlockNesting
