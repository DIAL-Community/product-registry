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
  task :clean_website  => :environment do
    Organization.all.each do |organization|
      previous_website = organization.website
      organization.website = organization.website
                                         .strip
                                         .sub(/^https?\:\/\//i,'')
                                         .sub(/^https?\/\/\:/i,'')
                                         .sub(/\/$/, '')
      if (organization.save)
        puts "Website changed: #{previous_website} -> #{organization.website}"
      end
    end
  end

  task :clean_enum => :environment do
    Location.where(location_type: 'country').update_all(type: 'country')
    Location.where(location_type: 'point').update_all(type: 'point')
  end

  task :associate_with_organization => :environment do
    organization_setting = Setting.find_by(slug: Rails.configuration.settings['install_org_key'])
    if organization_setting
      installation_organization = Organization.find_by(slug: organization_setting.value)
      return if installation_organization.nil?

      unassociated_users = User.where('role NOT IN (?)', ['org_user', 'org_product_user', 'product_user'])
      unassociated_users.each do |user|
        # Update the organization and skip the validation.
        user.organization_id = installation_organization.id
        user.save(validate: false)
      end
    end
  end

  task :update_desc => :environment do
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

  task :i18n_desc => :environment do
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

  task :sdg_desc => :environment do
    sdg_data = File.read('utils/sdgs.json')
    json_sdg = JSON.parse(sdg_data)
    json_sdg.each do |sdg|
      update_sdg_desc(sdg['code'], sdg['description'])
    end
  end

  task :create_principles => :environment do
    principle_data = File.read('utils/digital_principles.json')
    json_principles = JSON.parse(principle_data)
    json_principles.each do |curr_principle|
      principle = DigitalPrinciple.where(name: curr_principle["name"]).first || DigitalPrinciple.new
      principle.name = curr_principle["name"]
      principle.slug = curr_principle["slug"]
      principle.url = curr_principle["url"]
      principle.phase = curr_principle["phase"]
      principle.save

      desc = PrincipleDescription.new
      desc.digital_principle_id = principle.id
      desc.description = curr_principle["description"]
      desc.locale = I18n.locale
      desc.save
    end
  end

  task :migrate_editor_data => :environment do

    Product.all.each do | product |
      puts "PRODUCT: " + product.name
      product_description = ProductDescription.where(product_id: product, locale: I18n.locale)
                                               .first
      if !product_description.nil?
        desc = product_description.description.gsub("\\\"", "\"").gsub("\\\\","\\").delete_prefix('"').delete_suffix('"')
        begin 
          json_desc = JSON.parse desc
          puts "JSON: " + json_desc.inspect
          if json_desc['ops'].nil?
            product_description.description = ''
          else
            text_desc = json_desc['ops'][0]['insert']
            puts "TEXT: " + text_desc.to_s
            product_description.description = text_desc
          end
          product_description.save
        rescue JSON::ParserError => e
        end
      end
    end

    Organization.all.each do | org |
      puts "ORGANIZATION: " + org.name
      org_description = OrganizationDescription.where(organization_id: org, locale: I18n.locale)
                                               .first
      if !org_description.nil?
        desc = org_description.description.gsub("\\\"", "\"").gsub("\\\\","\\").delete_prefix('"').delete_suffix('"')
        begin 
          json_desc = JSON.parse desc
          puts "JSON: " + json_desc.inspect
          if json_desc['ops'].nil?
            org_description.description = ''
          else
            text_desc = json_desc['ops'][0]['insert']
            puts "TEXT: " + text_desc.to_s
            org_description.description = text_desc
          end
          org_description.save
        rescue JSON::ParserError => e
        end
      end
    end

    Project.all.each do | project |
      puts "PROJECT: " + project.name
      project_description = ProjectDescription.where(project_id: project, locale: I18n.locale)
                                               .first
      if !project_description.nil?
        desc = project_description.description.gsub("\\\"", "\"").gsub("\\\\","\\").delete_prefix('"').delete_suffix('"')
        begin 
          json_desc = JSON.parse desc
          puts "JSON: " + json_desc.inspect
          if json_desc['ops'].nil?
            project_description.description = ''
          else
            text_desc = json_desc['ops'][0]['insert']
            puts "TEXT: " + text_desc.to_s
            project_description.description = text_desc
          end
          project_description.save
        rescue JSON::ParserError => e
        end
      end
    end

    MaturityRubric.all.each do | rubric |
      puts "RUBRIC: " + rubric.name
      rubric_description = MaturityRubricDescription.where(maturity_rubric_id: rubric, locale: I18n.locale)
                                               .first
      if !rubric_description.nil?
        rubric_description.description = rubric_description.description_html
        rubric_description.save
      end
    end

    RubricCategory.all.each do | category |
      puts "CATEGORY: " + category.name
      category_description = RubricCategoryDescription.where(rubric_category_id: category, locale: I18n.locale)
                                               .first
      if !category_description.nil?
        category_description.description = category_description.description_html
        category_description.save
      end
    end

    CategoryIndicator.all.each do | indicator |
      puts "INDICATOR: " + indicator.name
      indicator_description = CategoryIndicatorDescription.where(category_indicator_id: indicator, locale: I18n.locale)
                                               .first
      if !indicator_description.nil?
        indicator_description.description = indicator_description.description_html
        indicator_description.save
      end
    end

  end

  task :descriptions_to_json => :environment do
    server_uri = URI.parse("https://solutions.dial.community/use_cases.json")
    response = Net::HTTP.get(server_uri)
    use_case_list = JSON.parse(response)
    json_out = uc_to_json(use_case_list)
    File.write("export/use_cases.json", json_out.to_json)

    server_uri = URI.parse("https://solutions.dial.community/workflows.json")  
    response = Net::HTTP.get(server_uri)
    workflow_list = JSON.parse(response)
    json_out = wf_to_json(workflow_list)
    File.write("export/workflows.json", json_out.to_json)

    server_uri = URI.parse("https://solutions.dial.community/building_blocks.json")  
    response = Net::HTTP.get(server_uri)
    bb_list = JSON.parse(response)
    json_out = bb_to_json(bb_list)
    File.write("export/building_blocks.json", json_out.to_json)

    server_uri = URI.parse("https://solutions.dial.community/organizations.json?without_paging=true")  
    response = Net::HTTP.get(server_uri)
    org_list = JSON.parse(response)
    json_out = org_to_json(org_list)
    File.write("export/organizations.json", json_out.to_json)

    server_uri = URI.parse("https://solutions.dial.community/products.json?without_paging=true")  
    response = Net::HTTP.get(server_uri)
    prod_list = JSON.parse(response)
    json_out = prod_to_json(prod_list)
    File.write("export/products.json", json_out.to_json)

    server_uri = URI.parse("https://solutions.dial.community/projects.json?without_paging=true")  
    response = Net::HTTP.get(server_uri)
    prod_list = JSON.parse(response)
    json_out = proj_to_json(prod_list)
    File.write("export/projects.json", json_out.to_json)

    server_uri = URI.parse("https://solutions.dial.community/sectors.json?without_paging=true")  
    response = Net::HTTP.get(server_uri)
    prod_list = JSON.parse(response)
    json_out = sector_to_json(prod_list)
    File.write("export/sectors.json", json_out.to_json)
  end

  task :add_discourse_topics => :environment do
    products = Product.where("id in (select product_id from products_endorsers) and parent_product_id is null")
    products.each do |product|
      if product.discourse_id.nil?
        topic_id = create_discourse_topic(product, 'Products')
        puts "Topic: " + topic_id.to_s
        product.discourse_id = topic_id
        product.save
      end
    end
    
    #building_blocks = BuildingBlock.all
    #building_blocs.each do |bb|
    #bb = BuildingBlock.all.first
    #  if bb.discourse_id.nil?
    #    topic_id = create_discourse_topic(bb, 'Building Blocks')
    #    puts "Topic: " + topic_id.to_s
    #    bb.discourse_id = topic_id
    #    bb.save
    #  end
    #end
  end

  task :sync_discourse_ids => :environment do
    discourse_ids = []
    ActiveRecord.with_db("sync-production") do
      discourse_ids = ActiveRecord::Base.connection.exec_query("SELECT name, slug, discourse_id FROM products where discourse_id IS NOT null")
    end
    puts "DISCOURSE_IDs: " + discourse_ids.rows.inspect
    discourse_ids.rows.each do |prod|
      dev_prod = Product.find_by(slug: prod[1])
      dev_prod.discourse_id = prod[2]
      dev_prod.save
    end
  end

  task :add_usernames => :environment do
    users = User.all
    users.each do |user| 
      if user.username.nil?
        user.username = user.email.split('@').first
        user.save
      end
    end
  end

  task :update_sectors => :environment do 
    # Set all current sectors to is_displayable = false
    Sector.all.update_all(is_displayable: false)

    dial_origin = Origin.where(slug: 'dial_osc').first
    sector_list = CSV.parse(File.read("./utils/sectors.csv"), headers: true)
    sector_list.each do |sector|
      if sector['Sub Sector'].nil?
        puts "Parent Sector: " + sector["Parent Sector"].strip
        # Check to see if this sector exists
        curr_sector = Sector.where("name = ?", sector["Parent Sector"].strip).first
        if curr_sector.nil? 
          puts "Create Parent sector"
          curr_sector = Sector.new
          curr_sector.name = sector["Parent Sector"].strip
          curr_sector.slug = slug_em(curr_sector.name)
          curr_sector.is_displayable = true
          curr_sector.origin_id = dial_origin.id
          curr_sector.locale = 'en'
          curr_sector.save
        else
          puts "Parent Sector already exists"
          # set displayable to true and clear parent_sector_id and save
          curr_sector.is_displayable = true
          curr_sector.parent_sector_id = nil
          curr_sector.save
        end
      else
        puts "Sub Sector: " + sector["Sub Sector"].strip
        # Look up parent sector ID
        parent_sector = Sector.where("name = ?", sector["Parent Sector"].strip).first
        if !parent_sector.nil?
          curr_sector = Sector.where("name = ?", sector["Parent Sector"].strip + ': ' + sector["Sub Sector"].strip).first
          if curr_sector.nil? 
            puts "Create Sub sector"
            curr_sector = Sector.new
            curr_sector.name = sector["Parent Sector"].strip + ': ' + sector["Sub Sector"].strip
            curr_sector.slug = slug_em(curr_sector.name, 64)
            curr_sector.parent_sector_id = parent_sector.id
            curr_sector.is_displayable = true
            curr_sector.origin_id = dial_origin.id
            curr_sector.locale = 'en'
            curr_sector.save
          else
            puts "Sub Sector already exists - assign to parent"
            curr_sector.name = sector["Parent Sector"].strip + ': ' + sector["Sub Sector"].strip
            curr_sector.slug = slug_em(curr_sector.name, 64)
            curr_sector.is_displayable = true
            curr_sector.parent_sector_id = parent_sector.id
            curr_sector.origin_id = dial_origin.id
            curr_sector.save
          end
        else
          puts "COULD NOT FIND PARENT SECTOR"
        end
      end
    end
  end

  task :remap_products => :environment do 
    # Now remap products, use cases, and organizations
    # Project remapping will happen in project sync
    sector_map = File.read('utils/sector_map.json')
    sector_json = JSON.parse(sector_map)

    Product.all.each do |prod|
      new_sectors = []
      prod.sectors.each do |sector|
        if sector_json[sector[:slug]]
          puts "New Sector: " + sector_json[sector[:slug]]
          new_sector = Sector.find_by(slug: sector_json[sector[:slug]])
          if !new_sector.nil? 
            if !new_sectors.include? new_sector
              new_sectors << new_sector
            end
          else
            if sector.is_displayable
              new_sectors << sector
            end
          end
        end
      end
      # Clear sectors
      prod.sectors = new_sectors
      prod.save
    end

    Organization.all.each do |org|
      new_sectors = []
      org.sectors.each do |sector|
        if sector_json[sector[:slug]]
          puts "New Sector: " + sector_json[sector[:slug]]
          new_sector = Sector.find_by(slug: sector_json[sector[:slug]])
          if !new_sector.nil? 
            if !new_sectors.include? new_sector
              new_sectors << new_sector
            end
          else
            if sector.is_displayable
              new_sectors << sector
            end
          end
        end
      end
      # Clear sectors
      org.sectors = new_sectors
      org.save
    end   
    
    UseCase.all.each do |use_case|
      uc_sector = Sector.find(use_case.sector_id)
      if sector_json[uc_sector[:slug]]
        puts "New Sector: " + sector_json[uc_sector[:slug]]
        new_sector = Sector.find_by(slug: sector_json[uc_sector[:slug]])
        if !new_sector.nil? 
          use_case.sector_id = new_sector.id
        else
          if uc_sector.is_displayable
            use_case.sector_id = uc_sector.id
          end
        end
      end
      use_case.save
    end   
  end

  task :map_project_sectors => :environment do 
    project_list = CSV.parse(File.read("./utils/project_sectors.csv"), headers: true)
    project_list.each do |project|
      curr_project = Project.find_by(name: project["Project Name"])
      if !curr_project.nil?
        all_sectors = GetSectors(project, nil)
        all_sectors.each do |curr_sector|   
          if !curr_project.sectors.include?(curr_sector)
            puts "Assiging Sector: " + curr_sector.inspect
            curr_project.sectors << curr_sector
          end
        end
        curr_project.save
      end
    end
  end

  task :map_product_sectors => :environment do 
    product_list = CSV.parse(File.read("./utils/product_sectors.csv"), headers: true)
    product_list.each do |product|
      curr_product = Product.find_by(slug: product["slug"])
      if !curr_product.nil?
        all_sectors = GetSectors(nil, product)
        all_sectors.each do |curr_sector|   
          if !curr_product.sectors.include?(curr_sector)
            puts "Assiging Sector: " + curr_sector.inspect
            curr_product.sectors << curr_sector
          end
        end
        curr_product.save
      end
    end
  end

  task :i18n_sectors => :environment do 
    dial_origin = Origin.where(slug: 'dial_osc').first

    de_data = File.read('utils/sectors.de.json')
    de_sectors = JSON.parse(de_data)
    fr_data = File.read('utils/sectors.fr.json')
    fr_sectors = JSON.parse(fr_data)
    sectors = YAML.load_file('utils/sectors.yml')
    sectors['sectors'].each_with_index do |sector, i|
      english_sector = Sector.find_by(name: sector['name'].gsub("_", ": "), locale: 'en')
      puts "English: " + english_sector.name
      german_name = de_sectors['sectors'][i]['name'].split('-')
      german_parent = Sector.find_by(name: german_name[0].strip)
      if german_parent.nil? 
        german_sector = Sector.new
        german_sector.slug = english_sector.slug
        german_sector.name = de_sectors['sectors'][i]['name']
        german_sector.locale = 'de'
        german_sector.is_displayable = true
        german_sector.origin = dial_origin
        german_sector.save!
      end
      if !german_name[1].nil?
        german_child = Sector.find_by(name: german_name[0].strip + ": " + german_name[1].strip, parent_sector_id: german_parent.id)
        if german_child.nil?
          german_sector = Sector.new
          german_sector.slug = english_sector.slug
          german_sector.name = german_name[0].strip + ": " + german_name[1].strip
          german_sector.locale = 'de'
          german_sector.is_displayable = true
          german_sector.parent_sector_id = german_parent.id
          german_sector.origin = dial_origin
          german_sector.save!
        end
      end

      french_name = fr_sectors['sectors'][i]['name'].split('-')
      french_parent = Sector.find_by(name: french_name[0].strip)
      if french_parent.nil? 
        french_sector = Sector.new
        french_sector.slug = english_sector.slug
        french_sector.name = fr_sectors['sectors'][i]['name']
        french_sector.locale = 'fr'
        french_sector.is_displayable = true
        french_sector.origin = dial_origin
        french_sector.save
      end
      if !french_name[1].nil?
        french_child = Sector.find_by(name: french_name[0].strip + ": " + french_name[1].strip, parent_sector_id: french_parent.id)
        if french_child.nil?
          french_sector = Sector.new
          french_sector.slug = english_sector.slug
          french_sector.name = french_name[0].strip + ": " + french_name[1].strip
          french_sector.locale = 'fr'
          french_sector.is_displayable = true
          french_sector.parent_sector_id = french_parent.id
          french_sector.origin = dial_origin
          french_sector.save
        end
      end
    end

    # Now map all products and projects to their German and French sectors
    ProductSector.all.each do |prod_sector|
      sector = Sector.find_by(id: prod_sector.sector_id)
      product = Product.find_by(id: prod_sector.product_id)

      if !sector.nil?
        german_sector = Sector.find_by(slug: sector.slug, locale: 'de')
        french_sector = Sector.find_by(slug: sector.slug, locale: 'fr')
      end

      if !product.nil? && !german_sector.nil? && !product.sectors.include?(german_sector)
        puts "Assigning sector: " + german_sector.name
        product.sectors << german_sector
        product.save
      end

      if !product.nil? && !french_sector.nil? && !product.sectors.include?(french_sector)
        product.sectors << french_sector
        product.save
      end
    end

    ProjectsSector.all.each do |proj_sector|
      sector = Sector.find_by(id: proj_sector.sector_id)
      project = Project.find_by(id: proj_sector.project_id)

      if !sector.nil?
        german_sector = Sector.find_by(slug: sector.slug, locale: 'de')
        french_sector = Sector.find_by(slug: sector.slug, locale: 'fr')
      end

      if !project.nil? && !german_sector.nil? && !project.sectors.include?(german_sector)
        puts "Assigning sector: " + german_sector.name
        project.sectors << german_sector
        project.save
      end

      if !project.nil? && !french_sector.nil? && !project.sectors.include?(french_sector)
        project.sectors << french_sector
        project.save
      end
    end

    OrganizationsSector.all.each do |org_sector|
      sector = Sector.find_by(id: org_sector.sector_id)
      org = Organization.find_by(id: org_sector.organization_id)

      if !sector.nil?
        german_sector = Sector.find_by(slug: sector.slug, locale: 'de')
        french_sector = Sector.find_by(slug: sector.slug, locale: 'fr')
      end

      if !org.nil? && !german_sector.nil? && !org.sectors.include?(german_sector)
        puts "Assigning sector: " + german_sector.name
        org.sectors << german_sector
        org.save
      end

      if !org.nil? && !french_sector.nil? && !org.sectors.include?(french_sector)
        org.sectors << french_sector
        org.save
      end
    end
  end

  task :i18n_products => :environment do 
    de_data = File.read('utils/product_desc.de.json')
    de_desc = JSON.parse(de_data)
    Product.all.each do |product|
      eng_desc = ProductDescription.find_by(product_id: product.id, locale: 'en')
      if !de_desc[product.name].nil?
        prod_desc = ProductDescription.find_by(product_id: product.id, locale: 'de')
        if prod_desc.nil?
          prod_desc = ProductDescription.new
          prod_desc.product_id = product.id
          prod_desc.locale = 'de'
        end

        if !de_desc[product.name]['description'].nil?
          prod_desc.description = de_desc[product.name]['description']
          prod_desc.save
        else
          if !eng_desc.nil?
            prod_desc.description = eng_desc.description
            prod_desc.save
          end
        end
      end

      prod_desc = ProductDescription.find_by(product_id: product.id, locale: 'fr')
      if prod_desc.nil? && !eng_desc.nil?
        prod_desc = ProductDescription.new
        prod_desc.product_id = product.id
        prod_desc.locale = 'fr'
        prod_desc.description = eng_desc.description
        prod_desc.save
      end
    end

    Project.all.each do |project|
      eng_desc = ProjectDescription.find_by(project_id: project.id, locale: 'en')
      proj_desc = ProjectDescription.find_by(project_id: project.id, locale: 'de')
      if proj_desc.nil?
        if !eng_desc.nil?
          proj_desc = ProjectDescription.new
          proj_desc.project_id = project.id
          proj_desc.locale = 'de'
          proj_desc.description = eng_desc.description
          proj_desc.save
        end
      end

      proj_desc = ProjectDescription.find_by(project_id: project.id, locale: 'fr')
      if proj_desc.nil?
        if !eng_desc.nil?
          proj_desc = ProjectDescription.new
          proj_desc.project_id = project.id
          proj_desc.locale = 'fr'
          proj_desc.description = eng_desc.description
          proj_desc.save
        end
      end
    end

    Organization.all.each do |org|
      eng_desc = OrganizationDescription.find_by(organization_id: org.id, locale: 'en')
      org_desc = OrganizationDescription.find_by(organization_id: org.id, locale: 'de')
      if org_desc.nil?
        if !eng_desc.nil?
          org_desc = OrganizationDescription.new
          org_desc.organization_id = org.id
          org_desc.locale = 'de'
          org_desc.description = eng_desc.description
          org_desc.save
        end
      end

      org_desc = OrganizationDescription.find_by(organization_id: org.id, locale: 'fr')
      if org_desc.nil?
        if !eng_desc.nil?
          org_desc = OrganizationDescription.new
          org_desc.organization_id = org.id
          org_desc.locale = 'fr'
          org_desc.description = eng_desc.description
          org_desc.save
        end
      end
    end
  end
end
