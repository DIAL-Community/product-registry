# frozen_string_literal: true

require 'modules/update_desc'
require 'modules/discourse'
require 'modules/connection_switch'
require 'modules/data_cleaning'
require 'csv'
include Modules::UpdateDesc
include Modules::Discourse
include Modules::ConnectionSwitch
include Modules::DataCleaning

namespace :data do
  desc 'Data related rake tasks.'
  task clean_website: :environment do
    Organization.all.each do |organization|
      previous_website = organization.website
      organization.website = organization.website
                                         .strip
                                         .sub(/^https?:\/\//i, '')
                                         .sub(/^https?\/\/:/i, '')
                                         .sub(/\/$/, '')
      puts "Website changed: #{previous_website} -> #{organization.website}" if organization.save
    end
  end

  task clean_enum: :environment do
    Location.where(location_type: 'country').update_all(type: 'country')
    Location.where(location_type: 'point').update_all(type: 'point')
  end

  task associate_with_organization: :environment do
    organization_setting = Setting.find_by(slug: Rails.configuration.settings['install_org_key'])
    if organization_setting
      installation_organization = Organization.find_by(slug: organization_setting.value)
      return if installation_organization.nil?

      unassociated_users = User.where('role NOT IN (?)', %w[org_user org_product_user product_user])
      unassociated_users.each do |user|
        # Update the organization and skip the validation.
        user.organization_id = installation_organization.id
        user.save(validate: false)
      end
    end
  end

  task update_desc: :environment do
    bb_data = File.read('utils/building_blocks.json')
    json_bb = JSON.parse(bb_data)
    json_bb.each do |bb|
      update_bb_desc(bb['slug'], bb['description'])
    end

    workflow_data = File.read('utils/workflows.json')
    json_workflow = JSON.parse(workflow_data)
    json_workflow.each do |workflow|
      update_workflow_desc(workflow['slug'], workflow['description'])
    end

    use_case_data = File.read('utils/use_case.json')
    json_use_case = JSON.parse(use_case_data)
    json_use_case.each do |use_case|
      update_use_case_desc(use_case['slug'], use_case['description'])
    end
  end

  task i18n_desc: :environment do
    I18n.locale = :en
    BuildingBlock.all.each do |bb|
      bb_desc = BuildingBlockDescription.new
      bb_desc.building_block_id = bb.id
      bb_desc.description = bb.description
      bb_desc.locale = I18n.locale
      bb_desc.save
    end

    UseCase.all.each do |uc|
      uc_desc = UseCaseDescription.new
      uc_desc.use_case_id = uc.id
      uc_desc.description = uc.description
      uc_desc.locale = I18n.locale
      uc_desc.save
    end

    Workflow.all.each do |wf|
      wf_desc = WorkflowDescription.new
      wf_desc.workflow_id = wf.id
      wf_desc.description = wf.description
      wf_desc.locale = I18n.locale
      wf_desc.save
    end
  end

  task sdg_desc: :environment do
    sdg_data = File.read('utils/sdgs.json')
    json_sdg = JSON.parse(sdg_data)
    json_sdg.each do |sdg|
      update_sdg_desc(sdg['code'], sdg['description'])
    end
  end

  task create_principles: :environment do
    principle_data = File.read('utils/digital_principles.json')
    json_principles = JSON.parse(principle_data)
    json_principles.each do |curr_principle|
      principle = DigitalPrinciple.where(name: curr_principle['name']).first || DigitalPrinciple.new
      principle.name = curr_principle['name']
      principle.slug = curr_principle['slug']
      principle.url = curr_principle['url']
      principle.phase = curr_principle['phase']
      principle.save

      desc = PrincipleDescription.new
      desc.digital_principle_id = principle.id
      desc.description = curr_principle['description']
      desc.locale = I18n.locale
      desc.save
    end
  end

  task migrate_editor_data: :environment do
    Product.all.each do |product|
      puts "PRODUCT: #{product.name}"
      product_description = ProductDescription.where(product_id: product, locale: I18n.locale)
                                              .first
      next if product_description.nil?

      desc = product_description.description.gsub('"', '"').gsub('\\\\',
                                                                 '\\').delete_prefix('"').delete_suffix('"')
      begin
        json_desc = JSON.parse(desc)
        puts "JSON: #{json_desc.inspect}"
        if json_desc['ops'].nil?
          product_description.description = ''
        else
          text_desc = json_desc['ops'][0]['insert']
          puts "Text: #{text_desc}"
          product_description.description = text_desc
        end
        product_description.save
      rescue JSON::ParserError => e
        puts "Exception when parsing product json data from editor. Message: #{e}."
      end
    end

    Organization.all.each do |org|
      puts "Organization: #{org.name}"
      org_description = OrganizationDescription.where(organization_id: org, locale: I18n.locale)
                                               .first
      next if org_description.nil?

      desc = org_description.description.gsub('"', '"').gsub('\\\\', '\\').delete_prefix('"').delete_suffix('"')
      begin
        json_desc = JSON.parse(desc)
        puts "JSON: #{json_desc.inspect}"
        if json_desc['ops'].nil?
          org_description.description = ''
        else
          text_desc = json_desc['ops'][0]['insert']
          puts "Text: #{text_desc}"
          org_description.description = text_desc
        end
        org_description.save
      rescue JSON::ParserError => e
        puts "Exception when parsing organization data from editor. Message: #{e}."
      end
    end

    Project.all.each do |project|
      puts "Project: #{project.name}"
      project_description = ProjectDescription.where(project_id: project, locale: I18n.locale)
                                              .first
      next if project_description.nil?

      desc = project_description.description.gsub('"', '"').gsub('\\\\',
                                                                 '\\').delete_prefix('"').delete_suffix('"')
      begin
        json_desc = JSON.parse(desc)
        puts "JSON: #{json_desc.inspect}"
        if json_desc['ops'].nil?
          project_description.description = ''
        else
          text_desc = json_desc['ops'][0]['insert']
          puts "TEXT: #{text_desc}"
          project_description.description = text_desc
        end
        project_description.save
      rescue JSON::ParserError => e
        puts "Exception when parsing project json data from editor. Message: #{e}."
      end
    end

    RubricCategory.all.each do |category|
      puts "Category: #{category.name}"
      category_description = RubricCategoryDescription.where(rubric_category_id: category, locale: I18n.locale)
                                                      .first
      unless category_description.nil?
        category_description.description = category_description.description_html
        category_description.save
      end
    end

    CategoryIndicator.all.each do |indicator|
      puts "Indicator: #{indicator.name}"
      indicator_description = CategoryIndicatorDescription.where(category_indicator_id: indicator, locale: I18n.locale)
                                                          .first
      unless indicator_description.nil?
        indicator_description.description = indicator_description.description_html
        indicator_description.save
      end
    end
  end

  task descriptions_to_json: :environment do
    server_uri = URI.parse('https://solutions.dial.community/use_cases.json')
    response = Net::HTTP.get(server_uri)
    use_case_list = JSON.parse(response)
    json_out = uc_to_json(use_case_list)
    File.write('export/use_cases.json', json_out.to_json)

    server_uri = URI.parse('https://solutions.dial.community/workflows.json')
    response = Net::HTTP.get(server_uri)
    workflow_list = JSON.parse(response)
    json_out = wf_to_json(workflow_list)
    File.write('export/workflows.json', json_out.to_json)

    server_uri = URI.parse('https://solutions.dial.community/building_blocks.json')
    response = Net::HTTP.get(server_uri)
    bb_list = JSON.parse(response)
    json_out = bb_to_json(bb_list)
    File.write('export/building_blocks.json', json_out.to_json)

    server_uri = URI.parse('https://solutions.dial.community/organizations.json?without_paging=true')
    response = Net::HTTP.get(server_uri)
    org_list = JSON.parse(response)
    json_out = org_to_json(org_list)
    File.write('export/organizations.json', json_out.to_json)

    server_uri = URI.parse('https://solutions.dial.community/products.json?without_paging=true')
    response = Net::HTTP.get(server_uri)
    prod_list = JSON.parse(response)
    json_out = prod_to_json(prod_list)
    File.write('export/products.json', json_out.to_json)

    server_uri = URI.parse('https://solutions.dial.community/projects.json?without_paging=true')
    response = Net::HTTP.get(server_uri)
    prod_list = JSON.parse(response)
    json_out = proj_to_json(prod_list)
    File.write('export/projects.json', json_out.to_json)

    server_uri = URI.parse('https://solutions.dial.community/sectors.json?without_paging=true')
    response = Net::HTTP.get(server_uri)
    prod_list = JSON.parse(response)
    json_out = sector_to_json(prod_list)
    File.write('export/sectors.json', json_out.to_json)
  end

  task add_usernames: :environment do
    users = User.all
    users.each do |user|
      if user.username.nil?
        user.username = user.email.split('@').first
        user.save
      end
    end
  end

  task update_sectors: :environment do
    # Set all current sectors to is_displayable = false
    Sector.all.update_all(is_displayable: false)

    dial_origin = Origin.where(slug: 'dial_osc').first
    sector_list = CSV.parse(File.read('./utils/sectors.csv'), headers: true)
    sector_list.each do |sector|
      if sector['Sub Sector'].nil?
        puts "Parent Sector: #{sector['Parent Sector'].strip}"
        # Check to see if this sector exists
        curr_sector = Sector.where('name = ?', sector['Parent Sector'].strip).first
        if curr_sector.nil?
          puts 'Create Parent sector'
          curr_sector = Sector.new
          curr_sector.name = sector['Parent Sector'].strip
          curr_sector.slug = slug_em(curr_sector.name)
          curr_sector.is_displayable = true
          curr_sector.origin_id = dial_origin.id
          curr_sector.locale = 'en'
        else
          puts 'Parent Sector already exists'
          # set displayable to true and clear parent_sector_id and save
          curr_sector.is_displayable = true
          curr_sector.parent_sector_id = nil
        end
        curr_sector.save
      else
        puts "Sub Sector: #{sector['Sub Sector'].strip}"
        # Look up parent sector ID
        parent_sector = Sector.where('name = ?', sector['Parent Sector'].strip).first
        if !parent_sector.nil?
          curr_sector = Sector.where('name = ?',
                                     "#{sector['Parent Sector'].strip}: #{sector['Sub Sector'].strip}").first
          if curr_sector.nil?
            puts 'Create Sub sector'
            curr_sector = Sector.new
            curr_sector.name = "#{sector['Parent Sector'].strip}: #{sector['Sub Sector'].strip}"
            curr_sector.slug = slug_em(curr_sector.name, 64)
            curr_sector.parent_sector_id = parent_sector.id
            curr_sector.is_displayable = true
            curr_sector.origin_id = dial_origin.id
            curr_sector.locale = 'en'
          else
            puts 'Sub Sector already exists - assign to parent'
            curr_sector.name = "#{sector['Parent Sector'].strip}: #{sector['Sub Sector'].strip}"
            curr_sector.slug = slug_em(curr_sector.name, 64)
            curr_sector.is_displayable = true
            curr_sector.parent_sector_id = parent_sector.id
            curr_sector.origin_id = dial_origin.id
          end
          curr_sector.save
        else
          puts 'COULD NOT FIND PARENT SECTOR'
        end
      end
    end
  end

  task remap_products: :environment do
    # Now remap products, use cases, and organizations
    # Project remapping will happen in project sync
    sector_map = File.read('utils/sector_map.json')
    sector_json = JSON.parse(sector_map)

    Product.all.each do |prod|
      new_sectors = []
      prod.sectors.each do |sector|
        next unless sector_json[sector[:slug]]

        puts "New Sector: #{sector_json[sector[:slug]]}"
        new_sector = Sector.find_by(slug: sector_json[sector[:slug]])
        if !new_sector.nil?
          new_sectors << new_sector unless new_sectors.include?(new_sector)
        elsif sector.is_displayable
          new_sectors << sector
        end
      end
      # Clear sectors
      prod.sectors = new_sectors
      prod.save
    end

    Organization.all.each do |org|
      new_sectors = []
      org.sectors.each do |sector|
        next unless sector_json[sector[:slug]]

        puts "New Sector: #{sector_json[sector[:slug]]}"
        new_sector = Sector.find_by(slug: sector_json[sector[:slug]])
        if !new_sector.nil?
          new_sectors << new_sector unless new_sectors.include?(new_sector)
        elsif sector.is_displayable
          new_sectors << sector
        end
      end
      # Clear sectors
      org.sectors = new_sectors
      org.save
    end

    UseCase.all.each do |use_case|
      uc_sector = Sector.find(use_case.sector_id)
      if sector_json[uc_sector[:slug]]
        puts "New Sector: #{sector_json[uc_sector[:slug]]}"
        new_sector = Sector.find_by(slug: sector_json[uc_sector[:slug]])
        if !new_sector.nil?
          use_case.sector_id = new_sector.id
        elsif uc_sector.is_displayable
          use_case.sector_id = uc_sector.id
        end
      end
      use_case.save
    end
  end

  task map_project_sectors: :environment do
    project_list = CSV.parse(File.read('./utils/project_sectors.csv'), headers: true)
    project_list.each do |project|
      curr_project = Project.find_by(name: project['Project Name'])
      next if curr_project.nil?

      all_sectors = find_sectors(project, nil)
      all_sectors.each do |curr_sector|
        unless curr_project.sectors.include?(curr_sector)
          puts "Assiging Sector: #{curr_sector.inspect}"
          curr_project.sectors << curr_sector
        end
      end
      curr_project.save
    end
  end

  task map_product_sectors: :environment do
    product_list = CSV.parse(File.read('./utils/product_sectors.csv'), headers: true)
    product_list.each do |product|
      curr_product = Product.find_by(slug: product['slug'])
      next if curr_product.nil?

      all_sectors = find_sectors(nil, product)
      all_sectors.each do |curr_sector|
        unless curr_product.sectors.include?(curr_sector)
          puts "Assiging Sector: #{curr_sector.inspect}"
          curr_product.sectors << curr_sector
        end
      end
      curr_product.save
    end
  end

  task i18n_sectors: :environment do
    dial_origin = Origin.where(slug: 'dial_osc').first

    sectors = YAML.load_file('utils/sectors.yml')
    %w[es pt sw].each do |locale|
      new_sectors = YAML.load_file("utils/sectors.#{locale}.yml")
      sectors['sectors'].each_with_index do |sector, i|
        english_sector = Sector.find_by(name: sector['name'].gsub('_', ': '), locale: 'en')
        puts "English: #{english_sector.name}"
        new_name = new_sectors['sectors'][i]['name'].split('-')
        puts "ES NAME: #{new_name}"
        new_parent = Sector.find_by(name: new_name[0].strip)
        if new_parent.nil?
          new_sector = Sector.new
          new_sector.slug = english_sector.slug
          new_sector.name = new_sectors['sectors'][i]['name']
          new_sector.locale = locale
          new_sector.is_displayable = true
          new_sector.origin = dial_origin
          new_sector.save!
        end
        next if new_name[1].nil?

        new_child = Sector.find_by(name: "#{new_name[0].strip}: #{new_name[1].strip}",
                                   parent_sector_id: new_parent.id)
        next unless new_child.nil?

        new_sector = Sector.new
        new_sector.slug = english_sector.slug
        new_sector.name = "#{new_name[0].strip}: #{new_name[1].strip}"
        new_sector.locale = locale
        new_sector.is_displayable = true
        new_sector.parent_sector_id = new_parent.id
        new_sector.origin = dial_origin
        new_sector.save!
      end
    end

    # Now map all products and projects to their German and French sectors
    ProductSector.all.each do |prod_sector|
      sector = Sector.find_by(id: prod_sector.sector_id, locale: 'en')
      product = Product.find_by(id: prod_sector.product_id)

      next if sector.nil?

      %w[es pt sw].each do |locale|
        new_sector = Sector.find_by(slug: sector.slug, locale: locale)

        next unless !product.nil? && !new_sector.nil? && !product.sectors.include?(new_sector)

        puts "Assigning sector: #{new_sector.name}"
        product.sectors << new_sector
        product.save
      end
    end

    ProjectsSector.all.each do |proj_sector|
      sector = Sector.find_by(id: proj_sector.sector_id, locale: 'en')
      project = Project.find_by(id: proj_sector.project_id)

      next if sector.nil?

      %w[es pt sw].each do |locale|
        new_sector = Sector.find_by(slug: sector.slug, locale: locale)

        next unless !project.nil? && !new_sector.nil? && !project.sectors.include?(new_sector)

        puts "Assigning sector: #{new_sector.name}"
        project.sectors << new_sector
        project.save
      end
    end

    OrganizationsSector.all.each do |org_sector|
      sector = Sector.find_by(id: org_sector.sector_id, locale: 'en')
      org = Organization.find_by(id: org_sector.organization_id)

      next if sector.nil?

      %w[es pt sw].each do |locale|
        new_sector = Sector.find_by(slug: sector.slug, locale: locale)

        next unless !org.nil? && !new_sector.nil? && !org.sectors.include?(new_sector)

        puts "Assigning sector: #{new_sector.name}"
        org.sectors << new_sector
        org.save
      end
    end
  end

  task i18n_products: :environment do
    de_data = File.read('utils/product_desc.de.json')
    de_desc = JSON.parse(de_data)
    Product.all.each do |product|
      eng_desc = ProductDescription.find_by(product_id: product.id, locale: 'en')
      unless de_desc[product.name].nil?
        prod_desc = ProductDescription.find_by(product_id: product.id, locale: 'de')
        if prod_desc.nil?
          prod_desc = ProductDescription.new
          prod_desc.product_id = product.id
          prod_desc.locale = 'de'
        end

        if !de_desc[product.name]['description'].nil?
          prod_desc.description = de_desc[product.name]['description']
          prod_desc.save
        elsif !eng_desc.nil?
          prod_desc.description = eng_desc.description
          prod_desc.save
        end
      end

      prod_desc = ProductDescription.find_by(product_id: product.id, locale: 'fr')
      next unless prod_desc.nil? && !eng_desc.nil?

      prod_desc = ProductDescription.new
      prod_desc.product_id = product.id
      prod_desc.locale = 'fr'
      prod_desc.description = eng_desc.description
      prod_desc.save
    end

    Project.all.each do |project|
      eng_desc = ProjectDescription.find_by(project_id: project.id, locale: 'en')
      proj_desc = ProjectDescription.find_by(project_id: project.id, locale: 'de')
      if proj_desc.nil? && !eng_desc.nil?
        proj_desc = ProjectDescription.new
        proj_desc.project_id = project.id
        proj_desc.locale = 'de'
        proj_desc.description = eng_desc.description
        proj_desc.save
      end

      proj_desc = ProjectDescription.find_by(project_id: project.id, locale: 'fr')
      next unless proj_desc.nil?

      next if eng_desc.nil?

      proj_desc = ProjectDescription.new
      proj_desc.project_id = project.id
      proj_desc.locale = 'fr'
      proj_desc.description = eng_desc.description
      proj_desc.save
    end

    Organization.all.each do |org|
      eng_desc = OrganizationDescription.find_by(organization_id: org.id, locale: 'en')
      org_desc = OrganizationDescription.find_by(organization_id: org.id, locale: 'de')
      if org_desc.nil? && !eng_desc.nil?
        org_desc = OrganizationDescription.new
        org_desc.organization_id = org.id
        org_desc.locale = 'de'
        org_desc.description = eng_desc.description
        org_desc.save
      end

      org_desc = OrganizationDescription.find_by(organization_id: org.id, locale: 'fr')
      next unless org_desc.nil?

      next if eng_desc.nil?

      org_desc = OrganizationDescription.new
      org_desc.organization_id = org.id
      org_desc.locale = 'fr'
      org_desc.description = eng_desc.description
      org_desc.save
    end
  end
end
