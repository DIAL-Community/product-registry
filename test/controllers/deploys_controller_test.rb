require 'test_helper'

class DeploysControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  setup do
    sign_in FactoryBot.create(:user, role: :admin)
  end

  test "should get index" do
    get deploys_index_url
    assert_response :success
  end

end
