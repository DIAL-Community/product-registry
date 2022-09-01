# frozen_string_literal: true

namespace :data_processors do
  desc 'Process dataset spreadsheet and populate the json file.'
  task process_dataset_spreadsheet: :environment do
    base_export_directory = './exported_data/datasets'
    DialSpreadsheetData.where(spreadsheet_type: 'dataset').each do |spreadsheet_data|
      File.open("#{base_export_directory}/#{spreadsheet_data.slug}.json", 'w') do |json_file|
        json_file.write(spreadsheet_data.spreadsheet_data.to_json)
      end

      puts "Dataset json \"#{spreadsheet_data.slug}.json\" written to filesystem."
    end
  end

  desc 'Process product spreadsheet and populate the json file.'
  task process_product_spreadsheet: :environment do
    base_export_directory = './exported_data/products'
    DialSpreadsheetData.where(spreadsheet_type: 'product').each do |spreadsheet_data|
      File.open("#{base_export_directory}/#{spreadsheet_data.slug}.json", 'w') do |json_file|
        json_file.write(spreadsheet_data.spreadsheet_data.to_json)
      end

      puts "Product json \"#{spreadsheet_data.slug}.json\" written to filesystem."
    end
  end

  desc 'Process list of product json files and convert them to product.'
  task process_exported_json_files: :environment do
    base_export_directories = ['./exported_data/products/*.json', './exported_data/datasets/*.json']
    base_export_directories.each do |base_export_directory|
      Dir.glob(base_export_directory).map do |filename|
        json_representation = JSON.parse(File.read(filename))
        obj_type = 'product'
        if base_export_directory.include?('datasets')
          obj_type = 'dataset'
        end
        generated_product = generate_product(json_representation, obj_type)

        puts "#{obj_type.humanize} with name \"#{generated_product.name}\" saved."
        next if !json_representation['descriptions'].present? || json_representation['descriptions'].empty?

        json_representation['descriptions'].each do |description|
          product_description = ProductDescription.find_by(
            product_id: generated_product.id,
            locale: description['locale']
          ) if obj_type == 'product'

          product_description = DatasetDescription.find_by(
            dataset_id: generated_product.id,
            locale: description['locale']
          ) unless obj_type == 'product'

          if product_description.nil?
            product_description = ProductDescription.new if obj_type == 'product'
            product_description = DatasetDescription.new unless obj_type == 'product'
            product_description.product_id = generated_product.id if obj_type == 'product'
            product_description.dataset_id = generated_product.id unless obj_type == 'product'
            product_description.locale = description['locale']
          end

          product_description.description = description['description']
          if product_description.save
            puts "Saving description for \"#{generated_product.name}\" for locale \"#{product_description.locale}\"."
          end
        end
      end
    end
  end

  def generate_product(json_data, obj_type)
    slug = slug_em(json_data['name'])

    product = Product.find_by(slug: slug) if obj_type == 'product'
    product = Dataset.find_by(slug: slug) unless obj_type == 'product'
    # Found existing product, return the product and skip processing the rest of the json.
    # return product unless product.nil? || product.manual_update
    product = Product.new if obj_type == 'product' && product.nil?
    product = Dataset.new if obj_type == 'dataset' && product.nil?

    # Process the origin of the product.
    origin = Origin.find_by(name: json_data['origin'])
    origin = Origin.find_by(slug: 'dial_osc') if origin.nil?

    # Generate alias information for the product.
    valid_aliases = []
    aliases = json_data['aliases'].split(",") if json_data['aliases']
    valid_aliases = aliases.reject(&:empty?) if aliases && !aliases.empty?

    # Process the sector section of the json.
    sectors = []
    if json_data['sectors'].present? && !json_data['sectors'].empty?
      json_data['sectors'].each do |sector_list|
        sector_list['name'].split(';').each do |curr_sector|
          sector = Sector.find_by(slug: slug_em(curr_sector.strip), locale: 'en')
          sectors << sector unless sector.nil?
        end
      end
    end

    # Process the organization section of the json.
    product_building_blocks = []
    if json_data['buildingBlocks'].present? && !json_data['buildingBlocks'].empty?
      json_data['buildingBlocks'].each do |maybe_building_block|
        building_block = BuildingBlock.find_by(name: maybe_building_block['name'])

        # Go to the next one if the building block is fake one.
        next if building_block.nil?

        product_building_block = ProductBuildingBlock.new
        product_building_block.building_block = building_block
        product_building_block.product = product
        product_building_block.mapping_status = ProductBuildingBlock.mapping_status_types[:BETA]
        product_building_blocks << product_building_block unless product_building_block.nil?
      end
    end

    # Process the organization section of the json.
    use_case_steps = []
    if json_data['useCasesSteps'].present? && !json_data['useCasesSteps'].empty?
      json_data['useCasesSteps'].each do |maybe_use_case_step|
        use_case_step = UseCaseStep.find_by(name: maybe_use_case_step['name'])
        use_case_steps << use_case_step unless use_case_step.nil?
      end
    end

    # Process the organization section of the json.
    organizations = []
    if json_data['organizations'].present? && !json_data['organizations'].empty?
      json_data['organizations'].each do |organization|
        organization = Organization.find_by(name: organization['name'])
        organizations << organization unless organization.nil?
      end
    end

    # Process the sdg section of the json.
    sdgs = []
    if json_data['sdgs'].present? && !json_data['sdgs'].empty?
      json_data['sdgs'].each do |sdg_num|
        sdg = SustainableDevelopmentGoal.find_by(number: sdg_num['number'].to_i)
        sdgs << sdg unless sdg.nil?
      end
    end

    countries = []
    if json_data['geographicCoverage'].present? && !json_data['geographicCoverage'].empty?
      json_data['geographicCoverage'].split(',').each do |curr_country|
        country = Country.find_by(name: curr_country.strip)
        countries << country unless country.nil?
      end
    end

    # Resolve the type of the json entry.
    product_type = 'product'
    case obj_type
    when 'dataset'
      product_type = 'dataset'
    when 'content'
      product_type = 'content'
    when 'standard'
      product_type = 'standard'
    when 'ai_model'
      product_type = 'ai_model'
    end

    website = json_data['website'].delete_prefix("https://") unless json_data['website'].nil?

    tags = []
    json_data['tags'].to_s.split(',').each do |tag_name|
      tag = Tag.find_by('name ILIKE ?', tag_name.strip)
      tags << tag.name unless tag.nil?
    end

    product.update(
      name: json_data['name'],
      aliases: valid_aliases,
      slug: slug,
      # License is part of repository now, need to add repository url to the spreadsheet.
      # license: json_data['license'],
      # repository_url: json_data['repositoryUrl'],
      origins: [origin],
      sectors: sectors,
      product_building_blocks: product_building_blocks,
      organizations: organizations,
      sustainable_development_goals: sdgs,
      website: website,
      product_type: product_type,
      commercial_product: json_data['commercialProduct'].to_s == 'true',
      hosting_model: json_data['hostingModel'],
      pricing_model: json_data['pricingModel'],
      pricing_details: json_data['pricingDetails'],
      pricing_date: json_data['pricingDate'].blank? ? nil : Date.strptime(json_data['pricingDate'], "%m/%d/%Y"),
      pricing_url: json_data['pricingUrl'],
      tags: tags
    ) if obj_type == 'product'

    product.update(
      name: json_data['name'],
      aliases: valid_aliases,
      slug: slug,
      origins: [origin],
      sectors: sectors,
      organizations: organizations,
      sustainable_development_goals: sdgs,
      website: website,
      visualization_url: json_data['visualizationUrl'],
      time_range: json_data['timeRange'],
      countries: countries,
      geographic_coverage: json_data['geographicCoverage'],
      license: json_data['license'],
      languages: json_data['languages'],
      data_format: json_data['format'],
      tags: tags,
      dataset_type: product_type
    ) unless obj_type == 'product'

    product
  end

  desc 'Process list of product json files and assign sdgs.'
  task process_sdgs_from_json_files: :environment do
    base_export_directories = ['./exported_data/products/*.json', './exported_data/datasets/*.json']
    base_export_directories.each do |base_export_directory|
      Dir.glob(base_export_directory).map do |filename|
        json_data = JSON.parse(File.read(filename))
        obj_type = 'product'
        if base_export_directory.include?('datasets')
          obj_type = 'dataset'
        end

        slug = slug_em(json_data['name'])

        product = Product.find_by(slug: slug) if obj_type == 'product'
        product = Dataset.find_by(slug: slug) unless obj_type == 'product'
        # Found existing product, return the product and skip processing the rest of the json.
        next if product.nil?

        # Process the sdg section of the json.
        sdgs = []
        if json_data['sdgs'].present? && !json_data['sdgs'].empty?
          json_data['sdgs'].each do |sdg_num|
            sdg = SustainableDevelopmentGoal.find_by(number: sdg_num['number'].to_i)
            sdgs << sdg unless sdg.nil?
          end
        end

        product.sustainable_development_goals = sdgs

        unless product.save
          puts "Unable to save: \"#{generated_product.name}\"."
          next
        end
      end
    end
  end

  desc 'Process list of product json files and assign tags.'
  task process_tags_from_json_files: :environment do
    base_export_directories = ['./exported_data/products/*.json', './exported_data/datasets/*.json']
    base_export_directories.each do |base_export_directory|
      Dir.glob(base_export_directory).map do |filename|
        json_data = JSON.parse(File.read(filename))
        obj_type = 'product'
        if base_export_directory.include?('datasets')
          obj_type = 'dataset'
        end

        slug = slug_em(json_data['name'])

        product = Product.find_by(slug: slug) if obj_type == 'product'
        product = Dataset.find_by(slug: slug) unless obj_type == 'product'
        # Found existing product, return the product and skip processing the rest of the json.
        next if product.nil?

        # Process the sdg section of the json.
        if json_data['tags'].present? && !json_data['tags'].empty?
          product.tags = json_data['tags'].split(/\s*,\s*/)
        end

        unless product.save
          puts "Unable to save: \"#{generated_product.name}\"."
          next
        end
      end
    end
  end
end
