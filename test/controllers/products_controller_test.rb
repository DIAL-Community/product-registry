# frozen_string_literal: true

require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in FactoryBot.create(:user, username: 'admin', roles: [:admin])
    @product = products(:one)
  end

  test 'should get index' do
    get products_url
    assert_response :success
  end

  test 'search test' do
    get products_url(search: 'Product Again')
    assert_equal(1, assigns(:products).count)

    get products_url(search: 'InvalidProduct')
    assert_equal(0, assigns(:products).count)
  end

  test 'should get new' do
    get new_product_url
    assert_response :success
  end

  test 'creating product without logo should not fail' do
    post products_url, params: { product: { name: 'Some Name', slug: 'some_name' } }
    created_product = Product.last

    assert_equal created_product.name, 'Some Name'
    assert_redirected_to product_url(created_product)
  end

  test 'updating product without logo should not fail' do
    patch product_url(@product), params: { product: { name: 'Some New Name' } }

    updated_product = Product.find(@product.id)
    assert_equal updated_product.name, 'Some New Name'
    assert_redirected_to product_url(updated_product, locale: 'en')
  end

  test 'should create product' do
    uploaded_file = fixture_file_upload('files/logo.png', 'image/png')
    assert_difference('Product.count') do
      post products_url, params: { product: { name: @product.name, website: @product.website },
                                   duplicate: true, reslug: true, logo: uploaded_file }
    end

    assert_redirected_to product_url(Product.last)
  end

  test 'should show product' do
    get product_url(@product)
    assert_response :success
  end

  test 'should get edit' do
    get edit_product_url(@product)
    assert_response :success
  end

  test 'should update product' do
    uploaded_file = fixture_file_upload('files/logo.png', 'image/png')
    patch product_url(@product), params: { product: { name: @product.name, slug: @product.slug,
                                                      website: @product.website },
                                           logo: uploaded_file }
    assert_redirected_to product_url(@product, locale: 'en')
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
    sign_in FactoryBot.create(:user, username: 'user', email: 'user@some-email.com', user_products: [product.id])

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
      website: 'some-fancy-website.com'
    }, selected_sectors: {
      "#{sector.id}": sector.id
    }, other_names: ['', ' ', 'some-alias'] }

    patch(product_url(product), params: patch_params)
    get product_url(product)

    assert_equal('Some new product name', assigns(:product).name)
    assert_equal('some-fancy-website.com', assigns(:product).website)

    assert_not_equal('Product', assigns(:product).name)
    assert_not_equal('website.org', assigns(:product).website)

    assert_equal(1, assigns(:product).sectors.length)

    sign_in(
      FactoryBot.create(:user, username: 'nonadmin', email: 'some-admin@digitalimpactalliance.org', roles: [:admin])
    )

    patch(product_url(products(:two)), params: patch_params)
    get product_url(products(:two))

    assert_equal('Some new product name', assigns(:product).name)
    assert_equal('some-fancy-website.com', assigns(:product).website)
  end

  test 'Policy tests: Should only allow get' do
    sign_in FactoryBot.create(:user, username: 'nonadmin', email: 'nonadmin@digitalimpactalliance.org')

    get product_url(@product)
    assert_response :success

    get new_product_url
    assert_response :redirect

    get edit_product_url(@product)
    assert_response :redirect

    patch product_url(@product), params: { product: { name: @product.name, slug: @product.slug,
                                                      website: @product.website } }
    assert_response :redirect

    delete product_url(@product)
    assert_response :redirect
  end

  test 'favoriting should save to saved_products array' do
    delete(destroy_user_session_url)
    post(favorite_product_product_url(@product), as: :json)
    assert_response :unauthorized

    sign_in FactoryBot.create(:user, username: 'nonadmin', email: 'nonadmin@abba.org')

    last_user = User.last
    assert_equal(last_user.saved_products.length, 0)

    post(favorite_product_product_url(@product), as: :json)
    assert_response :ok

    last_user = User.last
    assert_equal(last_user.saved_products.length, 1)
  end

  test 'unfavoriting should remove from saved_products array' do
    delete(destroy_user_session_url)
    post(unfavorite_product_product_url(@product), as: :json)
    assert_response :unauthorized

    sign_in FactoryBot.create(:user, username: 'nonadmin', email: 'nonadmin@abba.org', saved_products: [@product.id])

    last_user = User.last
    assert_equal(last_user.saved_products.length, 1)

    post(unfavorite_product_product_url(@product), as: :json)
    assert_response :ok

    last_user = User.last
    assert_equal(last_user.saved_products.length, 0)
  end

  test 'product user allowed to edit own product' do
    delete(destroy_user_session_url)
    sign_in FactoryBot.create(:user, username: 'nonadmin', email: 'nonadmin@abba.org',
                                     roles: [User.user_roles[:product_user]],
                                     user_products: [@product.id, products(:three).id])

    get edit_product_url(@product)
    assert_response :success

    patch product_url(@product), params: { product: { name: 'Some New Name' } }

    updated_product = Product.find(@product.id)
    assert_redirected_to product_url(updated_product, locale: 'en')
    assert_equal updated_product.name, 'Some New Name'

    get edit_product_url(products(:three))
    assert_response :success

    get edit_product_url(products(:two))
    assert_response :redirect

    patch product_url(products(:two)), params: { product: { name: 'Some New Name' } }
    assert_response :redirect

    updated_product = Product.find(products(:two).id)
    assert_equal updated_product.name, 'Product Again'
  end

  test 'content writer user should be able to create product' do
    delete(destroy_user_session_url)
    sign_in FactoryBot.create(:user, username: 'nonadmin', email: 'nonadmin@abba.org', roles: ['content_writer'])

    uploaded_file = fixture_file_upload('files/logo.png', 'image/png')

    building_block = building_blocks(:one)
    organization = organizations(:one)
    included_product = products(:one)
    interop_product = products(:two)
    sector = sectors(:one)
    sustainable_development_goal = sustainable_development_goals(:one)

    assert_no_difference('Product.count') do
      post products_url, params: { product: { name: @product.name, website: @product.website },
                                   selected_building_blocks: { building_block.id => building_block.id },
                                   selected_sectors: { sector.id => sector.id },
                                   selected_sustainable_development_goals: {
                                     sustainable_development_goal.id => sustainable_development_goal.id
                                   },
                                   selected_included_products: { included_product.id => included_product.id },
                                   selected_interoperable_products: { interop_product.id => interop_product.id },
                                   selected_organizations: { organization.id => organization.id },
                                   duplicate: true, reslug: true, logo: uploaded_file }
    end
    assert_response :redirect
  end

  test 'content writer user shoud not be able to remove mappings' do
    uploaded_file = fixture_file_upload('files/logo.png', 'image/png')

    building_block = building_blocks(:one)
    organization = organizations(:one)
    included_product = products(:one)
    interop_product = products(:two)
    sector = sectors(:one)
    sustainable_development_goal = sustainable_development_goals(:one)

    assert_difference('Product.count') do
      post products_url, params: { product: { name: @product.name, website: @product.website },
                                   selected_building_blocks: { building_block.id => building_block.id },
                                   selected_sectors: { sector.id => sector.id },
                                   selected_sustainable_development_goals: {
                                     sustainable_development_goal.id => sustainable_development_goal.id
                                   },
                                   selected_included_products: { included_product.id => included_product.id },
                                   selected_interoperable_products: { interop_product.id => interop_product.id },
                                   selected_organizations: { organization.id => organization.id },
                                   duplicate: true, reslug: true, logo: uploaded_file }
    end

    created_product = Product.last
    assert_redirected_to product_url(created_product)

    assert_equal(created_product.building_blocks.length, 1)
    assert_equal(created_product.sectors.length, 1)
    assert_equal(created_product.sustainable_development_goals.length, 1)
    assert_equal(created_product.includes.length, 1)
    assert_equal(created_product.interoperates_with.length, 1)
    assert_equal(created_product.organizations.length, 1)

    created_audit = Audit.last
    assert_equal(created_audit.action, 'CREATED')
    assert_equal(created_audit.username, User.last.email)

    # Audit will have 3 elements:
    # * Base entity changes.
    # * Mapping changes (optional)
    # * Image changes (optional)
    assert_equal(created_audit.audit_changes.length, 3)

    mapping_changes_audit = created_audit.audit_changes[1]
    assert_equal(mapping_changes_audit.keys.length, 6)
    assert_equal(mapping_changes_audit['buildingblocks'].length, 1)
    assert_equal(mapping_changes_audit['sectors'].length, 1)
    assert_equal(mapping_changes_audit['sustainabledevelopmentgoals'].length, 1)
    assert_equal(mapping_changes_audit['contains'].length, 1)
    assert_equal(mapping_changes_audit['interoperates_with'].length, 1)
    assert_equal(mapping_changes_audit['organizations'].length, 1)

    delete(destroy_user_session_url)
    sign_in FactoryBot.create(:user, username: 'nonadmin', email: 'nonadmin@abba.org', roles: ['content_writer'])

    other_building_block = building_blocks(:two)
    patch product_url(created_product), params: {
      product: {
        name: created_product.name, website: created_product.website
      },
      selected_building_blocks: {
        building_block.id => building_block.id,
        other_building_block.id => other_building_block.id
      }
    }

    updated_product = Product.find(created_product.id)
    assert_redirected_to product_url(updated_product, locale: 'en')
    assert_equal(updated_product.building_blocks.length, 2)

    created_audit = Audit.last
    assert_equal(created_audit.action, 'UPDATED')
    assert_equal(created_audit.username, 'nonadmin@abba.org')

    # Audit will have 1 elements:
    # * Mapping changes (optional)
    assert_equal(created_audit.audit_changes.length, 1)

    mapping_changes_audit = created_audit.audit_changes[0]
    assert_equal(mapping_changes_audit['buildingblocks'].length, 1)

    other_sector = sectors(:two)
    patch product_url(updated_product), params: {
      product: {
        name: updated_product.name, website: updated_product.website
      },
      selected_sectors: {
        other_sector.id => other_sector.id
      }
    }

    updated_product = Product.find(updated_product.id)
    assert_redirected_to product_url(updated_product, locale: 'en')
    # Content writer users are not allowed to remove mapping, but allowed to add.
    assert_equal(updated_product.sectors.length, 2)

    created_audit = Audit.last
    assert_equal(created_audit.action, 'UPDATED')
    assert_equal(created_audit.username, 'nonadmin@abba.org')

    # Audit will have 1 elements:
    # * Mapping changes (optional)
    assert_equal(created_audit.audit_changes.length, 1)

    mapping_changes_audit = created_audit.audit_changes[0]
    assert_equal(mapping_changes_audit['sectors'].length, 1)

    patch product_url(updated_product), params: {
      product: {
        name: updated_product.name, website: updated_product.website
      },
      selected_sectors: {}
    }

    updated_product = Product.find(updated_product.id)
    assert_redirected_to product_url(updated_product, locale: 'en')
    # Content writer users are not allowed to remove mapping
    assert_equal(updated_product.sectors.length, 2)
  end

  test 'content editor user should be able to remove mapping' do
    delete(destroy_user_session_url)
    sign_in FactoryBot.create(:user, username: 'nonadmin', email: 'content_editor@abba.org', roles: ['content_editor'])

    uploaded_file = fixture_file_upload('files/logo.png', 'image/png')

    building_block = building_blocks(:one)
    organization = organizations(:one)
    included_product = products(:one)
    interop_product = products(:two)
    sector = sectors(:one)
    sustainable_development_goal = sustainable_development_goals(:one)
    project = projects(:one)

    assert_difference('Product.count') do
      post products_url, params: { product: { name: @product.name, website: @product.website },
                                   selected_building_blocks: { building_block.id => building_block.id },
                                   selected_sectors: { sector.id => sector.id },
                                   selected_sustainable_development_goals: {
                                     sustainable_development_goal.id => sustainable_development_goal.id
                                   },
                                   selected_included_products: { included_product.id => included_product.id },
                                   selected_interoperable_products: { interop_product.id => interop_product.id },
                                   selected_organizations: { organization.id => organization.id },
                                   selected_projects: { project.id => project.id },
                                   duplicate: true, reslug: true, logo: uploaded_file }
    end

    created_product = Product.last
    assert_redirected_to product_url(created_product)

    assert_equal(created_product.building_blocks.length, 1)
    assert_equal(created_product.sectors.length, 1)
    assert_equal(created_product.sustainable_development_goals.length, 1)
    assert_equal(created_product.includes.length, 1)
    assert_equal(created_product.interoperates_with.length, 1)
    assert_equal(created_product.organizations.length, 1)
    assert_equal(created_product.projects.length, 1)

    created_audit = Audit.last
    assert_equal(created_audit.action, 'CREATED')
    assert_equal(created_audit.username, 'content_editor@abba.org')

    # Audit will have 3 elements:
    # * Base entity changes.
    # * Mapping changes (optional)
    # * Image changes (optional)
    assert_equal(created_audit.audit_changes.length, 3)

    mapping_changes_audit = created_audit.audit_changes[1]
    assert_equal(mapping_changes_audit.keys.length, 7)
    assert_equal(mapping_changes_audit['buildingblocks'].length, 1)
    assert_equal(mapping_changes_audit['sectors'].length, 1)
    assert_equal(mapping_changes_audit['sustainabledevelopmentgoals'].length, 1)
    assert_equal(mapping_changes_audit['contains'].length, 1)
    assert_equal(mapping_changes_audit['interoperates_with'].length, 1)
    assert_equal(mapping_changes_audit['organizations'].length, 1)
    assert_equal(mapping_changes_audit['projects'].length, 1)

    other_building_block = building_blocks(:two)
    patch product_url(created_product), params: {
      product: {
        name: created_product.name, website: created_product.website
      },
      selected_building_blocks: {
        building_block.id => building_block.id,
        other_building_block.id => other_building_block.id
      }
    }

    updated_product = Product.find(created_product.id)
    assert_redirected_to product_url(updated_product, locale: 'en')
    assert_equal(updated_product.building_blocks.length, 2)

    created_audit = Audit.last
    assert_equal(created_audit.action, 'UPDATED')
    assert_equal(created_audit.username, 'content_editor@abba.org')

    # Audit will have 1 elements:
    # * Mapping changes (optional)
    assert_equal(created_audit.audit_changes.length, 1)

    mapping_changes_audit = created_audit.audit_changes[0]
    assert_equal(mapping_changes_audit['buildingblocks'].length, 1)

    other_sector = sectors(:two)
    patch product_url(updated_product), params: {
      product: {
        name: updated_product.name, website: updated_product.website
      },
      selected_sectors: {
        other_sector.id => other_sector.id
      }
    }

    updated_product = Product.find(updated_product.id)
    assert_redirected_to product_url(updated_product, locale: 'en')
    # Content editor users are allowed to remove and add mapping.
    assert_equal(updated_product.sectors.length, 1)

    created_audit = Audit.last
    assert_equal(created_audit.action, 'UPDATED')
    assert_equal(created_audit.username, 'content_editor@abba.org')

    # Audit will have 1 elements:
    # * Mapping changes (optional)
    assert_equal(created_audit.audit_changes.length, 1)

    mapping_changes_audit = created_audit.audit_changes[0]
    # One for removing original sector and one for adding new sector.
    assert_equal(mapping_changes_audit['sectors'].length, 2)

    patch product_url(updated_product), params: {
      product: {
        name: updated_product.name, website: updated_product.website
      },
      selected_sectors: {}
    }

    updated_product = Product.find(updated_product.id)
    assert_redirected_to product_url(updated_product, locale: 'en')
    # Content editor users are allowed to remove mapping
    assert_equal(updated_product.sectors.length, 1)

    created_audit = Audit.last
    assert_equal(created_audit.action, 'UPDATED')
    assert_equal(created_audit.username, 'content_editor@abba.org')

    # Audit will have 1 elements:
    # * Mapping changes (optional)
    assert_equal(created_audit.audit_changes.length, 1)
  end

  test 'opening product page should generate event record' do
    delete(destroy_user_session_url)
    sign_in FactoryBot.create(:user, username: 'nonadmin', email: 'nonadmin@abba.org', roles: ['content_writer'])

    number_of_user_events = UserEvent.count
    get product_url(@product)
    assert_equal(UserEvent.count, number_of_user_events + 2)

    last_user_event = UserEvent.last

    assert_equal(last_user_event.email, 'nonadmin@abba.org')
    assert_equal(last_user_event.extended_data['slug'], @product.slug)
    assert_equal(last_user_event.extended_data['name'], @product.name)
  end
end
