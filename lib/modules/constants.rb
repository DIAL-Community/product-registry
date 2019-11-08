# frozen_string_literal: true

module Modules
  # Constants for the application controller.
  module Constants
    ORGANIZATION_FILTER_KEYS = %w[countries endorser_only sectors years].freeze
    FRAMEWORK_FILTER_KEYS = %w[sdgs use_cases building_blocks workflows with_maturity_assessment
                               is_launchable origins products].freeze
  end
end
