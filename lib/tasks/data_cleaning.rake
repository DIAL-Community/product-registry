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
end
