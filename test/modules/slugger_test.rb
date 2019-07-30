require 'test_helper'
require 'modules/slugger'
include Modules::Slugger

class SluggerModuleTest < ActiveSupport::TestCase

  test "should slug digits" do
    assert_equal "123456789_011", slug_em("1234-56-789 011")
    assert_equal "1234_56_789_011", slug_em("1234 56 789 011")
  end
end
