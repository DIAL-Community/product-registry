# frozen_string_literal: true

require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'
require 'factory_bot'
require 'minitest/reporters'
Minitest::Reporters.use!(Minitest::Reporters::SpecReporter.new)

module ActiveSupport
  class TestCase
    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all
  end
end
