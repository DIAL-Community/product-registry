module Queries
  class UseCasesQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::UseCaseType], null: false

    def resolve(search:)
      use_cases = UseCase.order(:name)
      unless search.blank?
        use_cases = use_cases.name_contains(search)
      end
      use_cases
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
        use_cases = use_cases.name_contains(search)
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
end
