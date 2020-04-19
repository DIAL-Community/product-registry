# frozen_string_literal: true

module Modules
  # Constants for the application controller.
  module Constants
    ORGANIZATION_FILTER_KEYS = %w[countries endorser_only aggregator_only sectors years organizations projects].freeze
    FRAMEWORK_FILTER_KEYS = %w[sdgs use_cases building_blocks workflows with_maturity_assessment is_launchable
                               origins products tags].freeze
  end
end
