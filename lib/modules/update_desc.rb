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
  end
end