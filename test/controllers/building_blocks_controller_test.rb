require 'test_helper'

class BuildingBlocksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in FactoryBot.create(:user, username: 'admin', roles: [:admin])
    @building_block = building_blocks(:one)
  end

  test "should get index" do
    get building_blocks_url
    assert_response :success
  end

  test "search test" do
    get building_blocks_url(search: "BuildingBlock1")
    assert_equal(1, assigns(:building_blocks).count)

    get building_blocks_url(search: "InvalidBB")
    assert_equal(0, assigns(:building_blocks).count)
  end

  test "should get new" do
    get new_building_block_url
    assert_response :success
  end

  test "creating building_block without logo should not fail" do
    post building_blocks_url, params: { building_block: { name: "Some Name", slug: "some_name", maturity: 'BETA' } }
    created_building_block = BuildingBlock.last

    assert_equal created_building_block.name, "Some Name"
    assert_redirected_to building_block_url(created_building_block)
  end

  test "updating building_block without logo should not fail" do
    patch building_block_url(@building_block), params: { building_block: { name: "Some New Name" } }

    updated_building_block = BuildingBlock.find(@building_block.id)
    assert_equal updated_building_block.name, "Some New Name"
    assert_redirected_to building_block_url(updated_building_block, locale: 'en')
  end

  test "should create building_block" do
    assert_difference('BuildingBlock.count') do
      uploaded_file = fixture_file_upload('files/logo.png', 'image/png')
      post building_blocks_url, params: { building_block: { name: "Another BB", slug: "another_bb", maturity: 'BETA' },
                                          logo: uploaded_file }
    end

    assert_redirected_to building_block_url(BuildingBlock.last)
  end

  test "should show building_block" do
    get building_block_url(@building_block)
    assert_response :success
  end

  test "should get edit" do
    get edit_building_block_url(@building_block)
    assert_response :success
  end

  test "should update building_block" do
    uploaded_file = fixture_file_upload('files/logo.png', 'image/png')
    patch(
      building_block_url(@building_block),
      params: { building_block: { name: @building_block.name, slug: @building_block.slug }, logo: uploaded_file }
    )
    assert_redirected_to building_block_url(@building_block, locale: 'en')
  end

  test "should destroy building_block" do
    assert_difference('BuildingBlock.count', -1) do
      delete building_block_url(@building_block)
    end

    assert_redirected_to building_blocks_url
  end

  test "add building block filter" do
    # With no filters, should load 2 building blocks
    get building_blocks_url
    assert_equal(2, assigns(:building_blocks).count)
    bb1 = assigns(:building_blocks)[0]
    bb2 = assigns(:building_blocks)[1]

    param = { 'filter_name' => 'building_blocks', 'filter_value' => bb1.id, 'filter_label' => bb1.name }
    post "/add_filter", params: param

    # Filter is set, should only load 1
    get building_blocks_url
    assert_equal(1, assigns(:building_blocks).count)

    # Now add a workflow filter
    param = {
      'filter_name' => 'workflows',
      'filter_value' => bb2.workflows[0].id,
      'filter_label' => bb2.workflows[0].name
    }
    post "/add_filter", params: param

    # With additional filter, should now load 0
    get building_blocks_url
    assert_equal(0, assigns(:building_blocks).count)
  end

  test "Policy tests: Should only allow get" do
    sign_in FactoryBot.create(:user, username: 'nonadmin', email: 'nonadmin@digitalimpactalliance.org')

    get building_block_url(@building_block)
    assert_response :success

    get new_building_block_url
    assert_response :redirect

    get edit_building_block_url(@building_block)
    assert_response :redirect

    patch(
      building_block_url(@building_block),
      params: { building_block: { name: @building_block.name, slug: @building_block.slug } }
    )
    assert_response :redirect

    delete building_block_url(@building_block)
    assert_response :redirect
  end

  test 'content writer user shoud not be able to remove mappings' do
    uploaded_file = fixture_file_upload('files/logo.png', 'image/png')

    product = products(:one)
    workflow = workflows(:one)

    assert_difference('BuildingBlock.count') do
      post building_blocks_url, params: { building_block: { name: @building_block.name, maturity: 'BETA' },
                                          selected_products: { product.id => product.id },
                                          selected_workflows: { workflow.id => workflow.id },
                                          duplicate: true, reslug: true, logo: uploaded_file }
    end

    created_building_block = BuildingBlock.last
    assert_redirected_to building_block_url(created_building_block)

    assert_equal(created_building_block.products.length, 1)
    assert_equal(created_building_block.workflows.length, 1)

    created_audit = Audit.last
    assert_equal(created_audit.action, 'CREATED')
    assert_equal(created_audit.username, User.last.email)

    # Audit will have 3 elements:
    # * Base entity changes.
    # * Mapping changes (optional)
    # * Image changes (optional)
    assert_equal(created_audit.audit_changes.length, 3)

    mapping_changes_audit = created_audit.audit_changes[1]
    assert_equal(mapping_changes_audit.keys.length, 2)
    assert_equal(mapping_changes_audit['products'].length, 1)
    assert_equal(mapping_changes_audit['workflows'].length, 1)

    delete(destroy_user_session_url)
    sign_in FactoryBot.create(:user, username: 'nonadmin', email: 'nonadmin@abba.org', roles: ['content_writer'])

    other_product = products(:two)
    patch building_block_url(created_building_block), params: {
      building_block: {
        name: created_building_block.name
      },
      selected_products: {
        product.id => product.id,
        other_product.id => other_product.id
      }
    }

    updated_building_block = BuildingBlock.find(created_building_block.id)
    assert_redirected_to building_block_url(updated_building_block, locale: 'en')
    assert_equal(updated_building_block.products.length, 2)

    created_audit = Audit.last
    assert_equal(created_audit.action, 'UPDATED')
    assert_equal(created_audit.username, 'nonadmin@abba.org')

    # Audit will have 1 elements:
    # * Mapping changes (optional)
    assert_equal(created_audit.audit_changes.length, 1)

    mapping_changes_audit = created_audit.audit_changes[0]
    assert_equal(mapping_changes_audit['products'].length, 1)

    patch building_block_url(updated_building_block), params: {
      building_block: {
        name: updated_building_block.name
      },
      selected_products: {
        other_product.id => other_product.id
      }
    }

    updated_building_block = BuildingBlock.find(updated_building_block.id)
    assert_redirected_to building_block_url(updated_building_block, locale: 'en')
    # Content writer users are not allowed to remove mapping, but allowed to add.
    assert_equal(updated_building_block.products.length, 2)
  end

  test 'content editor user should be able to remove mapping' do
    delete(destroy_user_session_url)
    sign_in FactoryBot.create(:user, username: 'nonadmin', email: 'content_editor@abba.org', roles: ['content_editor'])

    uploaded_file = fixture_file_upload('files/logo.png', 'image/png')

    product = products(:one)
    workflow = workflows(:one)

    assert_difference('BuildingBlock.count') do
      post building_blocks_url, params: { building_block: { name: @building_block.name, maturity: 'BETA' },
                                          selected_products: { product.id => product.id },
                                          selected_workflows: { workflow.id => workflow.id },
                                          duplicate: true, reslug: true, logo: uploaded_file }
    end

    created_building_block = BuildingBlock.last
    assert_redirected_to building_block_url(created_building_block)

    assert_equal(created_building_block.products.length, 1)
    assert_equal(created_building_block.workflows.length, 1)

    created_audit = Audit.last
    assert_equal(created_audit.action, 'CREATED')
    assert_equal(created_audit.username, 'content_editor@abba.org')

    # Audit will have 3 elements:
    # * Base entity changes.
    # * Mapping changes (optional)
    # * Image changes (optional)
    assert_equal(created_audit.audit_changes.length, 3)

    mapping_changes_audit = created_audit.audit_changes[1]
    assert_equal(mapping_changes_audit.keys.length, 2)
    assert_equal(mapping_changes_audit['products'].length, 1)
    assert_equal(mapping_changes_audit['workflows'].length, 1)

    other_product = products(:two)
    patch building_block_url(created_building_block), params: {
      building_block: {
        name: created_building_block.name
      },
      selected_products: {
        product.id => product.id,
        other_product.id => other_product.id
      }
    }

    updated_building_block = BuildingBlock.find(created_building_block.id)
    assert_redirected_to building_block_url(updated_building_block, locale: 'en')
    assert_equal(updated_building_block.products.length, 2)

    created_audit = Audit.last
    assert_equal(created_audit.action, 'UPDATED')
    assert_equal(created_audit.username, 'content_editor@abba.org')

    # Audit will have 1 elements:
    # * Mapping changes (optional)
    assert_equal(created_audit.audit_changes.length, 1)

    mapping_changes_audit = created_audit.audit_changes[0]
    assert_equal(mapping_changes_audit['products'].length, 1)

    another_product = products(:two)
    patch building_block_url(updated_building_block), params: {
      building_block: {
        name: updated_building_block.name
      },
      selected_products: {
        another_product.id => another_product.id
      }
    }

    updated_building_block = BuildingBlock.find(updated_building_block.id)
    assert_redirected_to building_block_url(updated_building_block, locale: 'en')
    # Content editor users are allowed to remove and add mapping.
    assert_equal(updated_building_block.products.length, 1)

    created_audit = Audit.last
    assert_equal(created_audit.action, 'UPDATED')
    assert_equal(created_audit.username, 'content_editor@abba.org')

    # Audit will have 1 elements:
    # * Mapping changes (optional)
    assert_equal(created_audit.audit_changes.length, 1)

    mapping_changes_audit = created_audit.audit_changes[0]
    # One for removing original sector and one for adding new sector.
    assert_equal(mapping_changes_audit['products'].length, 1)

    patch building_block_url(updated_building_block), params: {
      building_block: {
        name: updated_building_block.name
      },
      selected_products: {}
    }

    updated_building_block = BuildingBlock.find(updated_building_block.id)
    assert_redirected_to building_block_url(updated_building_block, locale: 'en')
    # Content editor users are allowed to remove mapping
    assert_equal(updated_building_block.products.length, 1)

    created_audit = Audit.last
    assert_equal(created_audit.action, 'UPDATED')
    assert_equal(created_audit.username, 'content_editor@abba.org')

    # Audit will have 1 elements:
    # * Mapping changes (optional)
    assert_equal(created_audit.audit_changes.length, 1)
  end
end
