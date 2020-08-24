require 'test_helper'

class ProductSuitesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in FactoryBot.create(:user, roles: [:admin])
    @product_suite = product_suites(:one)
  end

  test "should get index" do
    get product_suites_url
    assert_response :success
  end

  test "should get new" do
    get new_product_suite_url
    assert_response :success
  end

  test "should create product_suite" do
    assert_difference('ProductSuite.count') do
      post product_suites_url, params: { product_suite: { name: @product_suite.name, description: 'Some Description' },
                                         reslug: true }
    end

    assert_redirected_to product_suite_url(ProductSuite.last)
  end

  test "should show product_suite" do
    get product_suite_url(@product_suite)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_suite_url(@product_suite)
    assert_response :success
  end

  test "should update product_suite" do
    patch product_suite_url(@product_suite), params: { product_suite: { name: @product_suite.name } }
    assert_redirected_to product_suite_url(@product_suite)
  end

  test "should destroy product_suite" do
    assert_difference('ProductSuite.count', -1) do
      delete product_suite_url(@product_suite)
    end

    assert_redirected_to product_suites_url
  end
end
