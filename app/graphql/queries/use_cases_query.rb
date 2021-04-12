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
    type Types::UseCaseType.connection_type, null: false

    def resolve(search:, sdgs:)
      use_cases = UseCase.order(:name)
      unless search.blank?
        use_cases = use_cases.name_contains(search)
      end

      filtered_sdgs = sdgs.reject { |x| x.nil? || x.empty? }
      unless filtered_sdgs.empty?
        sdgs = SustainableDevelopmentGoal.where(id: sdgs)
                                         .select(:number)
        sdg_targets = SdgTarget.where('sdg_number in (?)', sdgs)
        use_cases = use_cases.joins(:sdg_targets)
                             .where(sdg_targets: { id: sdg_targets.ids })
      end
      use_cases
    end
  end
end
