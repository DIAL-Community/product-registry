require 'test_helper'

class LocationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in FactoryBot.create(:user, role: :admin)
    @location = locations(:one)
  end

  test "should get index" do
    get locations_url
    assert_response :success
  end

  test "search test" do
    get locations_url(:search=>"Location1")
    assert_equal(1, assigns(:locations).count)

    # Should not find location2, because it is a point location
    get locations_url(:search=>"Location2")
    assert_equal(0, assigns(:locations).count)

    get locations_url(:search=>"InvalidLocation")
    assert_equal(0, assigns(:locations).count)
  end

  test "should get new" do
    get new_location_url
    assert_response :success
  end

  test "should create location" do
    assert_difference('Location.count') do
      post locations_url, params: { location: { name: @location.name, slug: 'testslug' } }
    end

    assert_redirected_to location_url(Location.last)
  end

  test "should show location" do
    get location_url(@location)
    assert_response :success
  end

  test "should get edit" do
    get edit_location_url(@location)
    assert_response :success
  end

  test "should update location" do
    patch location_url(@location), params: { location: { name: @location.name, slug: @location.slug } }
    assert_redirected_to location_url(@location)
  end

  test "should destroy location" do
    assert_difference('Location.count', -1) do
      @project = projects(:one)
      delete project_url(@project)
      delete location_url(@location)
    end

    assert_redirected_to locations_url
  end

  test "Policy tests: should reject new, edit, update, delete actions for regular user. Should allow get" do
    sign_in FactoryBot.create(:user, email: 'nonadmin@digitalimpactalliance.org')

    get location_url(@location)
    assert_response :success
    
    get new_location_url
    assert_response :redirect

    get edit_location_url(@location)
    assert_response :redirect    

    patch location_url(@location), params: { location: { name: @location.name, slug: @location.slug } }
    assert_response :redirect  

    delete location_url(@location)
    assert_response :redirect
  end
end
