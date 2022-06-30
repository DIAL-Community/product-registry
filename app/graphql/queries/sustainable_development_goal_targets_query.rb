# frozen_string_literal: true

module Queries
  class SustainableDevelopmentGoalTargetsQuery < Queries::BaseQuery
    argument :search, String, required: false, default_value: ''
    type [Types::SustainableDevelopmentGoalTargetType], null: false

    def resolve(search:)
      sdg_targets = SdgTarget.order(:target_number)
      unless search.blank?
        sdg_targets = sdg_targets.where('LOWER(name) like LOWER(?)', "%#{search}%")
      end
      sdg_targets
    end
  end
end
