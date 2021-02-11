require 'modules/update_desc'
include Modules::UpdateDesc

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
      principle = DigitalPrinciple.new
      principle.name = curr_principle["name"]
      principle.slug = curr_principle["slug"]
      principle.url = curr_principle["url"]
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

  task :descriptions_to_html => :environment do
    server_uri = URI.parse("https://solutions.dial.community/use_cases.json")
    response = Net::HTTP.get(server_uri)
    use_case_list = JSON.parse(response)
    html_out = uc_to_html(use_case_list)
    File.write("export/use_cases.html", html_out)

    server_uri = URI.parse("https://solutions.dial.community/workflows.json")  
    response = Net::HTTP.get(server_uri)
    workflow_list = JSON.parse(response)
    html_out = wf_to_html(use_case_list)
    File.write("export/workflows.html", html_out)

    server_uri = URI.parse("https://solutions.dial.community/building_blocks.json")  
    response = Net::HTTP.get(server_uri)
    bb_list = JSON.parse(response)
    html_out = bb_to_html(bb_list)
    File.write("export/building_blocks.html", html_out)

    server_uri = URI.parse("https://solutions.dial.community/organizations.json?without_paging=true")  
    response = Net::HTTP.get(server_uri)
    org_list = JSON.parse(response)
    html_out = org_to_html(org_list)
    File.write("export/organizations.html", html_out)

    server_uri = URI.parse("https://solutions.dial.community/products.json?without_paging=true")  
    response = Net::HTTP.get(server_uri)
    prod_list = JSON.parse(response)
    html_out = prod_to_html(prod_list)
    File.write("export/products.html", html_out)
  end
end
