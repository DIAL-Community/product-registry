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

  test "should get new" do
    get new_sector_url
    assert_response :success
  end

  test "should create sector" do
    assert_difference('Sector.count') do
      post sectors_url, params: { sector: { name: @sector.name, slug: @sector.slug } }
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
      delete use_case_url(@sector)
      delete sector_url(@sector)
    end

    assert_redirected_to sectors_url
  end
end
