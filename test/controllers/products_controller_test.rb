require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in FactoryBot.create(:user, role: :admin)
    @product = products(:one)
  end

  test "should get index" do
    get products_url
    assert_response :success
  end

  test "search test" do
    get products_url(:search=>"Product Again")
    assert_equal(1, assigns(:products).count)

    get products_url(:search=>"InvalidProduct")
    assert_equal(0, assigns(:products).count)
  end

  test "should get new" do
    get new_product_url
    assert_response :success
  end

  test "should create product" do
    uploaded_file = fixture_file_upload('files/logo.png', 'image/png')
    assert_difference('Product.count') do
      post products_url, params: { product: { name: @product.name, website: @product.website }, duplicate: true, reslug: true, logo: uploaded_file }
    end

    assert_redirected_to product_url(Product.last)
  end

  test "should show product" do
    get product_url(@product)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_url(@product)
    assert_response :success
  end

  test "should update product" do
    uploaded_file = fixture_file_upload('files/logo.png', 'image/png')
    patch product_url(@product), params: { product: { name: @product.name, slug: @product.slug, website: @product.website }, logo: uploaded_file }
    assert_redirected_to product_url(@product)
  end

  test "Policy tests: should reject new, edit, update, delete actions for regular user. Should allow get" do
    sign_in FactoryBot.create(:user, email: 'nonadmin@digitalimpactalliance.org')

    get product_url(@product)
    assert_response :success
    
    get new_product_url
    assert_response :redirect

    get edit_product_url(@product)
    assert_response :redirect    

    patch product_url(@product), params: { product: { name: @product.name, slug: @product.slug, website: @product.website } }
    assert_response :redirect  

    delete product_url(@product)
    assert_response :redirect
  end

end
