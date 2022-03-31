# frozen_string_literal: true

module Modules
  module UpdateDesc
    def update_bb_desc(bb_slug, desc)
      bb_obj = BuildingBlock.find_by(slug: bb_slug)
      unless bb_obj.nil?
        bb_obj['description'] = desc
        puts "Building Block updated: #{bb_obj['slug']}." if bb_obj.save
      end
    end

    def update_workflow_desc(slug, desc)
      workflow_obj = Workflow.find_by(slug: slug)
      unless workflow_obj.nil?
        workflow_obj['description'] = desc
        puts "Workflow updated: #{workflow_obj['slug']}." if workflow_obj.save
      end
    end

    def update_use_case_desc(slug, desc)
      uc_obj = UseCase.find_by(slug: slug)
      unless uc_obj.nil?
        uc_obj['description'] = desc
        puts "Use Case updated: #{uc_obj['slug']}." if uc_obj.save
      end
    end

    def update_sdg_desc(sdg_number, desc)
      sdg_obj = SustainableDevelopmentGoal.find_by(number: sdg_number)
      unless sdg_obj.nil?
        sdg_obj['long_title'] = desc
        puts "Sustainable Development Goal updated: #{sdg_obj['number']}." if sdg_obj.save
      end
    end

    def uc_to_json(use_case_list)
      uc_json = {}
      use_case_list.each do |use_case|
        puts "USE CASE: #{use_case['name']}"
        uc_json[use_case['name']] = {}
        use_case['use_case_descriptions'].each do |uc_desc|
          uc_json[use_case['name']]['description'] = uc_desc['description'] if uc_desc['locale'] == 'en'
        end
        use_case_steps = use_case['use_case_steps']
        uc_json[use_case['name']]['steps'] = {} if use_case_steps.count
        use_case_steps.each do |uc_step|
          uc_json[use_case['name']]['steps'][uc_step['name']] = {}
          step_descriptions = uc_step['use_case_step_descriptions']
          step_descriptions.each do |step_desc|
            if step_desc['locale'] == 'en'
              uc_json[use_case['name']]['steps'][uc_step['name']]['description'] = step_desc['description']
            end
          end
        end
      end
      uc_json
    end

    def wf_to_json(workflow_list)
      wf_json = {}
      workflow_list.each do |workflow|
        puts "WORKFLOW: #{workflow['name']}"
        wf_json[workflow['name']] = {}
        workflow['workflow_descriptions']&.each do |wf_desc|
          wf_json[workflow['name']]['description'] = wf_desc['description'] if wf_desc['locale'] == 'en'
        end
      end
      wf_json
    end

    def bb_to_json(bb_list)
      bb_json = {}
      bb_list.each do |bb|
        puts "BUILDING BLOCK: #{bb['name']}"
        bb_json[bb['name']] = {}
        bb['building_block_descriptions']&.each do |bb_desc|
          bb_json[bb['name']]['description'] = bb_desc['description'] if bb_desc['locale'] == 'en'
        end
      end
      bb_json
    end

    def org_to_json(org_list)
      org_json = {}
      org_list.each do |org|
        puts "ORGANIZATION: #{org['name']}"
        org_json[org['name']] = {}
        org['organization_descriptions']&.each do |org_desc|
          org_json[org['name']]['description'] = org_desc['description'] if org_desc['locale'] == 'en'
        end
      end
      org_json
    end

    def prod_to_json(prod_list)
      prod_json = {}
      prod_list.each do |prod|
        puts "PRODUCT: #{prod['name']}"
        prod_json[prod['name']] = {}
        prod['product_descriptions']&.each do |prod_desc|
          prod_json[prod['name']]['description'] = prod_desc['description'] if prod_desc['locale'] == 'en'
        end
      end
      prod_json
    end

    def proj_to_json(proj_list)
      proj_json = {}
      proj_list.each do |proj|
        puts "PROJECT: #{proj['name']}"
        proj_json[proj['name']] = {}
        proj['project_descriptions']&.each do |proj_desc|
          proj_json[proj['name']]['description'] = proj_desc['description'] if proj_desc['locale'] == 'en'
        end
      end
      proj_json
    end

    def sector_to_json(sector_list)
      sector_json = {}
      sector_json['sectors'] = {}
      sector_list.each do |sector|
        puts "SECTOR: #{sector['name']}"
        sector_json['sectors'][sector['name']] = sector['name']
      end
      sector_json
    end
  end
end
