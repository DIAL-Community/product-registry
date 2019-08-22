# frozen_string_literal: true

require 'modules/constants'
module ApplicationHelper
  include Modules::Constants
  def all_filters
    ORGANIZATION_FILTER_KEYS + FRAMEWORK_FILTER_KEYS
  end
end
