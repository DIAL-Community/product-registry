module Modules
  module UpdateDesc
    def update_bb_desc(bb_slug, desc)
      bb_obj = BuildingBlock.find_by(slug: bb_slug)
      if !bb_obj.nil?
        bb_obj['description'] = desc
        if bb_obj.save
          puts "Building Block updated: #{bb_obj['slug']}."
        end
      end
    end

    def update_workflow_desc(slug, desc)
      workflow_obj = Workflow.find_by(slug: slug)
      if !workflow_obj.nil?
        workflow_obj['description'] = desc
        if workflow_obj.save
          puts "Workflow updated: #{workflow_obj['slug']}."
        end
      end
    end

    def update_use_case_desc(slug, desc)
      uc_obj = UseCase.find_by(slug: slug)
      if !uc_obj.nil?
        uc_obj['description'] = desc
        if uc_obj.save
          puts "Use Case updated: #{uc_obj['slug']}."
        end
      end
    end

    def update_sdg_desc(sdg_number, desc)
      sdg_obj = SustainableDevelopmentGoal.find_by(number: sdg_number)
      if !sdg_obj.nil?
        sdg_obj['long_title'] = desc
        if sdg_obj.save
          puts "Sustainable Development Goal updated: #{sdg_obj['number']}."
        end
      end
    end

    def update_sdg_desc(sdg_number, desc)
      sdg_obj = SustainableDevelopmentGoal.find_by(number: sdg_number)
      if !sdg_obj.nil?
        sdg_obj['long_title'] = desc
        if sdg_obj.save
          puts "Sustainable Development Goal updated: #{sdg_obj['number']}."
        end
      end
    end

    def uc_to_html(use_case_list)
      html_output = "<h1>Use Cases</h1>"
      use_case_list.each do |use_case|
        puts "USE CASE: " + use_case["name"]
        html_output += "<h2>"+use_case["name"]+"</h2>"
        use_case["use_case_descriptions"].each do |uc_desc|
          html_output += uc_desc["description"]
        end
        use_case_steps = use_case["use_case_steps"]
        if use_case_steps.count
          html_output += "<h3>Use Case Steps</h3>"
        end
        use_case_steps.each do |uc_step|
          html_output += "<h4>"+uc_step["name"]+"</h4>"
          step_descriptions = uc_step["use_case_step_descriptions"]
          step_descriptions.each do |step_desc|
            html_output += step_desc["description"]
          end
        end
      end
      html_output
    end

    def wf_to_html(workflow_list)
      html_output = "<h1>Workflows</h1>"
      workflow_list.each do |workflow|
        puts "WORKFLOW: " + workflow["name"]
        html_output += "<h2>"+workflow["name"]+"</h2>"
        workflow["workflow_descriptions"] && workflow["workflow_descriptions"].each do |wf_desc|
          html_output += wf_desc["description"]
        end
      end
      html_output
    end

    def bb_to_html(bb_list)
      html_output = "<h1>Building Blocks</h1>"
      bb_list.each do |bb|
        puts "BUILDING BLOCK: " + bb["name"]
        html_output += "<h2>"+bb["name"]+"</h2>"
        bb["building_block_descriptions"] && bb["building_block_descriptions"].each do |bb_desc|
          html_output += bb_desc["description"]
        end
      end
      html_output
    end

    def org_to_html(org_list)
      html_output = "<h1>Organizations</h1>"
      org_list.each do |org|
        puts "ORGANIZATION: " + org["name"]
        html_output += "<h2>"+org["name"]+"</h2>"
        org["organization_descriptions"] && org["organization_descriptions"].each do |org_desc|
          html_output += org_desc["description"]
        end
      end
      html_output
    end

    def prod_to_html(prod_list)
      html_output = "<h1>Products</h1>"
      prod_list.each do |prod|
        puts "PRODUCT: " + prod["name"]
        html_output += "<h2>"+prod["name"]+"</h2>"
        prod["product_descriptions"] && prod["product_descriptions"].each do |prod_desc|
          if prod_desc["locale"] == "en"
            html_output += prod_desc["description"]
          end
        end
      end
      html_output
    end

    def proj_to_html(proj_list)
      html_output = "<h1>Projects</h1>"
      proj_list.each do |proj|
        puts "PROJECT: " + proj["name"]
        html_output += "<h2>"+proj["name"]+"</h2>"
        proj["project_descriptions"] && proj["project_descriptions"].each do |proj_desc|
          if proj_desc["locale"] == "en"
            html_output += proj_desc["description"]
          end
        end
      end
      html_output
    end
  end
end