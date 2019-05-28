require 'test_helper'

class DeploysControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get deploys_index_url
    assert_response :success
  end

end
