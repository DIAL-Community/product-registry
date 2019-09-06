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
  end
end