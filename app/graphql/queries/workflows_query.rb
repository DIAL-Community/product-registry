module Queries
  class WorkflowsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::WorkflowType], null: false

    def resolve(search:)
      workflows = Workflow.order(:name)
      unless search.blank?
        workflows = workflows.name_contains(search)
      end
      workflows
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
        workflows = workflows.name_contains(search)
      end

      filtered_use_cases = use_cases.reject { |x| x.nil? || x.empty? }
      unless filtered_use_cases.empty?
        workflows = workflows.joins(:use_case_steps)
                             .where(use_case_steps: { use_case_id: filtered_use_cases })
      end
      workflows
    end
  end
end
