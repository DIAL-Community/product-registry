module Queries
  class SustainableDevelopmentGoalsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::SustainableDevelopmentGoalType], null: false

    def resolve(search:)
      sdgs = SustainableDevelopmentGoal.order(:name)
      unless search.blank?
        sdgs = sdgs.name_contains(search).order(:name)
      end
      sdgs
    end
  end

  class SearchSustainableDevelopmentGoalsQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper

    argument :search, String, required: false, default_value: ''
    argument :sdgs, [String], required: false, default_value: []
    type Types::SustainableDevelopmentGoalType.connection_type, null: false

    def resolve(search:, sdgs:)
      sustainable_development_goals = SustainableDevelopmentGoal.order(:name)
      unless search.blank?
        sustainable_development_goals = sustainable_development_goals.name_contains(search).order(:name)
      end

      filtered_sdgs = sdgs.reject { |x| x.nil? || x.empty? }
      unless filtered_sdgs.empty?
        sustainable_development_goals = sustainable_development_goals.where(id: sdgs)
      end
      sustainable_development_goals
    end
  end
end
