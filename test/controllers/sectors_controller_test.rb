require 'test_helper'

class SectorsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in FactoryBot.create(:user, role: :admin)
    @sector = sectors(:one)
  end

  test "should get index" do
    get sectors_url
    assert_response :success
  end

  test "search test" do
    get sectors_url(:search=>"Sector1")
    assert_equal(1, assigns(:sectors).count)

    get sectors_url(:search=>"InvalidSector")
    assert_equal(0, assigns(:sectors).count)
  end

  test "should get new" do
    get new_sector_url
    assert_response :success
  end

  test "should create sector" do
    assert_difference('Sector.count') do
      post sectors_url, params: { sector: { name: 'Another sector', slug: 'another_sector' } }
    end

    assert_redirected_to sector_url(Sector.last)
  end

  test "should show sector" do
    get sector_url(@sector)
    assert_response :success
  end

  test "should get edit" do
    get edit_sector_url(@sector)
    assert_response :success
  end

  test "should update sector" do
    patch sector_url(@sector), params: { sector: { name: @sector.name, slug: @sector.slug } }
    assert_redirected_to sector_url(@sector)
  end

  test "should destroy sector" do
    # Should not delete because it is referenced by a use case
    assert_difference('Sector.count', 0) do
      delete sector_url(@sector)
    end

    assert_difference('Sector.count', -1) do
      @use_case = use_cases(:one)
      delete use_case_url(@use_case)
      @project = projects(:one)
      delete project_url(@project)
      delete sector_url(@sector)
    end

    assert_redirected_to sectors_url
  end

  test "Policy tests: should reject new, edit, update, delete actions for regular user. Should allow get" do
    sign_in FactoryBot.create(:user, email: 'nonadmin@digitalimpactalliance.org')

    get sector_url(@sector)
    assert_response :success
    
    get new_sector_url
    assert_response :redirect

    get edit_sector_url(@sector)
    assert_response :redirect    

    patch sector_url(@sector), params: { sector: { name: @sector.name, slug: @sector.slug } }
    assert_response :redirect  

    delete sector_url(@sector)
    assert_response :redirect
  end
end
