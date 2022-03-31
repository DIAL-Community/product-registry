# frozen_string_literal: true

module Queries
  class WorkflowsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::WorkflowType], null: false

    def resolve(search:)
      workflows = Workflow.order(:name)
      workflows = workflows.name_contains(search) unless search.blank?
      workflows
    end
  end

  class WorkflowQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::WorkflowType, null: false

    def resolve(slug:)
      Workflow.find_by(slug: slug)
    end
  end

  class SearchWorkflowsQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper

    argument :search, String, required: false, default_value: ''
    argument :sdgs, [String], required: false, default_value: []
    argument :use_cases, [String], required: false, default_value: []
    type Types::WorkflowType.connection_type, null: false

    def resolve(search:, sdgs:, use_cases:)
      workflows = Workflow.order(:name)
      unless search.blank?
        name_workflow = workflows.name_contains(search)
        desc_workflow = workflows.joins(:workflow_descriptions)
                                 .where('LOWER(workflow_descriptions.description) like LOWER(?)', "%#{search}%")
        workflows = workflows.where(id: (name_workflow + desc_workflow).uniq)
      end

      filtered = false
      use_case_ids = []
      filtered_sdgs = sdgs.reject { |x| x.nil? || x.empty? }
      unless filtered_sdgs.empty?
        filtered = true
        sdg_numbers = SustainableDevelopmentGoal.where(id: filtered_sdgs)
                                                .select(:number)
        sdg_use_cases = UseCase.joins(:sdg_targets)
                               .where(sdg_targets: { sdg_number: sdg_numbers })
        use_case_ids.concat(sdg_use_cases.ids)
      end

      filtered_use_cases = use_cases.reject { |x| x.nil? || x.empty? }
      filtered ||= !filtered_use_cases.empty?

      filtered_use_cases = use_case_ids.concat(filtered_use_cases)
      if filtered
        if filtered_use_cases.empty?
          return []
        else
          workflows = workflows.joins(:use_case_steps)
                               .where(use_case_steps: { use_case_id: filtered_use_cases })
        end
      end
      workflows.distinct
    end
  end
end
