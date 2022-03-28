# frozen_string_literal: true

module Queries
  class SustainableDevelopmentGoalsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::SustainableDevelopmentGoalType], null: false

    def resolve(search:)
      sdgs = SustainableDevelopmentGoal.order(:number)
      unless search.blank?
        sdg_name = sdgs.name_contains(search)
        sdg_desc = sdgs.where('LOWER(long_title) like LOWER(?)', "%#{search}%")
        sdgs = sdgs.where(id: (sdg_name + sdg_desc).uniq)
      end
      sdgs
    end
  end

  class SustainableDevelopmentGoalQuery < Queries::BaseQuery
    argument :slug, String, required: true
    type Types::SustainableDevelopmentGoalType, null: false

    def resolve(slug:)
      SustainableDevelopmentGoal.find_by(slug: slug)
    end
  end

  class SearchSustainableDevelopmentGoalsQuery < Queries::BaseQuery
    include ActionView::Helpers::TextHelper

    argument :search, String, required: false, default_value: ''
    argument :sdgs, [String], required: false, default_value: []
    type Types::SustainableDevelopmentGoalType.connection_type, null: false

    def resolve(search:, sdgs:)
      sustainable_development_goals = SustainableDevelopmentGoal.order(:number)
      unless search.blank?
        sdg_name = sustainable_development_goals.name_contains(search)
        sdg_desc = sustainable_development_goals.where('LOWER(long_title) like LOWER(?)', "%#{search}%")
        sdg_target = sustainable_development_goals.joins(:sdg_targets)
                                                  .where('LOWER(sdg_targets.name) like LOWER(?)', "%#{search}%")
        sustainable_development_goals = sustainable_development_goals.where(id: (sdg_name + sdg_desc + sdg_target).uniq)
      end

      filtered_sdgs = sdgs.reject { |x| x.nil? || x.empty? }
      sustainable_development_goals = sustainable_development_goals.where(id: filtered_sdgs) unless filtered_sdgs.empty?
      sustainable_development_goals.distinct
    end
  end
end
