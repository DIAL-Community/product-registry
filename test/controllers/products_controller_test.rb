require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in FactoryBot.create(:user, roles: [:admin])
    @product = products(:one)
  end

  test "should get index" do
    get products_url
    assert_response :success
  end

  test "search test" do
    get products_url(search: 'Product Again')
    assert_equal(1, assigns(:products).count)

    get products_url(search: 'InvalidProduct')
    assert_equal(0, assigns(:products).count)
  end

  test "should get new" do
    get new_product_url
    assert_response :success
  end

  test "creating product without logo should not fail" do
    post products_url, params: { product: { name: "Some Name", slug: 'some_name' }}
    created_product = Product.last

    assert_equal created_product.name, "Some Name"
    assert_redirected_to product_url(created_product)
  end

  test "updating product without logo should not fail" do
    patch product_url(@product), params: { product: {name: "Some New Name" } }

    updated_product = Product.find(@product.id)
    assert_equal updated_product.name, "Some New Name"
    assert_redirected_to product_url(updated_product)
  end

  test "should create product" do
    uploaded_file = fixture_file_upload('files/logo.png', 'image/png')
    assert_difference('Product.count') do
      post products_url, params: { product: { name: @product.name, website: @product.website },
                                   duplicate: true, reslug: true, logo: uploaded_file }
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

  test 'should filter products' do
    # With no filters, should load 4 products
    get products_url
    assert_equal(4, assigns(:products).count)

    first_product = products(:one)
    first_origin = origins(:one)
    first_product.origins.push(first_origin)

    first_product.save

    # Origin filter: should return only the above product
    add_parameter = { 'filter_name': 'origins', 'filter_value': first_origin.id, 'filter_label': first_origin.name }
    post '/add_filter', params: add_parameter

    get products_url
    assert_equal(1, assigns(:products).count)
    assert_equal('Product', assigns(:products)[0].name)

    remove_parameter = { 'filter_array': { '0' => { filter_name: 'origins' } } }
    post '/remove_filter', params: remove_parameter

    get products_url
    assert_equal(4, assigns(:products).count)

    # Remove first product's assessment information.
    # * should return 2 products
    first_product.maturity_score = 0
    first_product.save

    add_parameter = { 'filter_name': 'with_maturity_assessment', 'filter_value': true }
    post '/add_filter', params: add_parameter

    get products_url
    assert_equal(2, assigns(:products).count)

    # Combination assessment with origins:
    # * should return 3 products
    add_parameter = { 'filter_name': 'origins', 'filter_value': first_origin.id, 'filter_label': first_origin.name }
    post '/add_filter', params: add_parameter

    get products_url
    assert_equal(0, assigns(:products).count)

    remove_parameter = { filter_array: { '0' => { filter_name: 'with_maturity_assessment' } } }
    post '/remove_filter', params: remove_parameter

    get products_url
    assert_equal(1, assigns(:products).count)
  end

  test 'Policy test: should follow product policy for user' do
    product = products(:one)
    sign_in FactoryBot.create(:user, email: 'user@some-email.com', products: [product])

    get product_url(product)
    assert_response :success
    assert_equal(product.name, assigns(:product).name)

    get edit_product_url(product)
    assert_response :success

    get edit_product_url(products(:two))
    assert_response :redirect

    sector = sectors(:one)

    patch_params = { product: {
      name: 'Some new product name',
      website: 'some-fancy-website.com',
    }, selected_sectors: {
      "#{sector.id}": sector.id
    }, other_names: ['', ' ', 'some-alias'] }

    patch(product_url(product), params: patch_params)
    get product_url(product)

    assert_not_equal('Some new product name', assigns(:product).name)
    assert_not_equal('some-fancy-website.com', assigns(:product).website)

    assert_equal('Product', assigns(:product).name)
    assert_equal('website.org', assigns(:product).website)

    assert_equal(1, assigns(:product).sectors.length)

    sign_in FactoryBot.create(:user, email: 'some-admin@digitalimpactalliance.org', roles: [:admin])

    patch(product_url(product), params: patch_params)
    get product_url(product)

    assert_equal('Some new product name', assigns(:product).name)
    assert_equal('some-fancy-website.com', assigns(:product).website)
  end

  test "Policy tests: Should only allow get" do
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
