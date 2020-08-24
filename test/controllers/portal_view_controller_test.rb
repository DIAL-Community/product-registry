require 'test_helper'

class PortalViewsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in FactoryBot.create(:user, roles: [:admin])
    @portal_view = portal_view(:one)
  end

  test "should get index" do
    get portal_views_url
    assert_response :success
  end

  test "should show setting" do
    get portal_view_url(@portal_view)
    assert_response :success
  end

  test "should get edit" do
    get edit_portal_view_url(@portal_view)
    assert_response :success
  end

  test "should update setting" do
    patch portal_view_url(@portal_view), params: { portal_view: { description: "test" } }
    assert_redirected_to portal_view_url(@portal_view)
  end

  test "should switch portals when role is removed" do
    sign_in FactoryBot.create(:user, email: 'nonadmin@digitalimpactalliance.org', role: :user)
    get portal_view_url(@portal_view)
    assert_equal(session['portal']['slug'], "portal_2")
  end
end
