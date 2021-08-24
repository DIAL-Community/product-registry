module Queries
  class UseCasesQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    argument :mature, Boolean, required: false, default_value: false
    type [Types::UseCaseType], null: false

    def resolve(search:, mature: )
      if mature
        use_cases = UseCase.where(maturity: 'MATURE').order(:name)
      else
        use_cases = UseCase.order(:name)
      end
      unless search.blank?
        use_cases = use_cases.name_contains(search)
      end
      use_cases
    end
  end

  class UseCaseQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::UseCaseType, null: false

    def resolve(slug:)
      use_case = UseCase.find_by(slug: slug)

      workflows = []
      if use_case.use_case_steps && !use_case.use_case_steps.empty?
        use_case.use_case_steps.each do |use_case_step|
          workflows |= use_case_step.workflows
        end
      end
      use_case.workflows = workflows.sort_by { |w| w.name.downcase }

      building_blocks = []
      workflows.each do |workflow|
        building_blocks |= workflow.building_blocks
      end
      use_case.building_blocks = building_blocks.sort_by { |b| b.name.downcase }
      use_case
    end
  end

  class SearchUseCasesQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper

    argument :search, String, required: false, default_value: ''
    argument :sdgs, [String], required: false, default_value: []
    argument :show_beta, Boolean, required: false, default_value: false
    type Types::UseCaseType.connection_type, null: false

    def resolve(search:, sdgs:, show_beta:)
      use_cases = UseCase.order(:name)
      unless search.blank?
        name_ucs = use_cases.name_contains(search)
        desc_ucs = use_cases.joins(:use_case_descriptions)
                            .where("LOWER(use_case_descriptions.description) like LOWER(?)", "%#{search}%")
        use_cases = use_cases.where(id: (name_ucs + desc_ucs).uniq)
      end

      filtered_sdgs = sdgs.reject { |x| x.nil? || x.empty? }
      unless filtered_sdgs.empty?
        sdg_numbers = SustainableDevelopmentGoal.where(id: filtered_sdgs)
                                                .select(:number)
        use_cases = use_cases.joins(:sdg_targets)
                             .where(sdg_targets: { sdg_number: sdg_numbers })
      end

      unless show_beta
        use_cases = use_cases.where(maturity: UseCase.entity_status_types[:MATURE])
      end

      use_cases.distinct
    end
  end

  class UseCaseStepsQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type [Types::UseCaseStepType], null: false

    def resolve(slug:)
      use_case = UseCase.find_by(slug: slug)
      UseCaseStep.where(use_case_id: use_case.id).order(step_number: :asc)
    end
  end

  class UseCaseStepQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::UseCaseStepType, null: false

    def resolve(slug:)
      use_case_step = UseCaseStep.find_by(slug: slug)

      unless use_case_step.nil?
        building_blocks = []
        if use_case_step&.workflows && !use_case_step.workflows.empty?
          use_case_step.workflows.each do |workflow|
            building_blocks |= workflow.building_blocks
          end
        end
        use_case_step.building_blocks = building_blocks.sort_by { |b| b.name.downcase }
      end

      use_case_step
    end
  end
end
