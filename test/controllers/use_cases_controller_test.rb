# frozen_string_literal: true

require 'test_helper'

class UseCasesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in FactoryBot.create(:user, username: 'admin', roles: [:admin], saved_use_cases: [])
    @use_case = use_cases(:one)
    @sectors = Sector.order(:name)
  end

  test 'should get index' do
    get use_cases_url
    assert_response :success
  end

  test 'search test' do
    get use_cases_url(search: 'UseCase1')
    assert_equal(1, assigns(:use_cases).count)

    get use_cases_url(search: 'InvalidUseCase')
    assert_equal(0, assigns(:use_cases).count)
  end

  test 'should get new' do
    get new_use_case_url
    assert_response :success
  end

  test 'should create use_case' do
    assert_difference('UseCase.count') do
      post use_cases_url, params: { use_case: { uc_desc: @use_case.description, name: @use_case.name,
                                                maturity: 'BETA',
                                                sector_id: @use_case.sector_id, slug: @use_case.slug } }
    end

    assert_redirected_to use_case_url(UseCase.last)
  end

  test 'should show use_case' do
    get use_case_url(@use_case)
    assert_response :success
  end

  test 'should get edit' do
    get edit_use_case_url(@use_case)
    assert_response :success
  end

  test 'should update use_case' do
    patch use_case_url(@use_case), params: { use_case: { uc_desc: @use_case.description, name: @use_case.name,
                                                         sector_id: @use_case.sector_id, slug: @use_case.slug } }
    assert_redirected_to use_case_url(@use_case, locale: 'en')
  end

  test 'should destroy use_case' do
    assert_difference('UseCase.count', -1) do
      delete use_case_url(@use_case)
    end

    assert_redirected_to use_cases_url
  end

  test 'add use_case filter' do
    # With no filters, should load 2 workflows
    get use_cases_url
    assert_equal(2, assigns(:use_cases).count)
    use_case1 = assigns(:use_cases)[0]
    use_case2 = assigns(:use_cases)[1]

    param = { 'filter_name' => 'use_cases', 'filter_value' => use_case1.id, 'filter_label' => use_case1.name }
    post '/add_filter', params: param

    # Filter is set, should only load 1
    get use_cases_url
    assert_equal(1, assigns(:use_cases).count)

    # Now add a workflow filter
    param = { 'filter_name' => 'workflows', 'filter_value' => use_case2.use_case_steps[0].workflows[0].id,
              'filter_label' => use_case2.use_case_steps[0].workflows[0].name }
    post '/add_filter', params: param

    # With additional filter, should now load 0
    get use_cases_url
    assert_equal(0, assigns(:use_cases).count)
  end

  test 'Policy tests: Should only allow get' do
    sign_in FactoryBot.create(:user, username: 'nonadmin', email: 'nonadmin@digitalimpactalliance.org')

    get use_case_url(@use_case)
    assert_response :success

    get new_use_case_url
    assert_response :redirect

    get edit_use_case_url(@use_case)
    assert_response :redirect

    patch(
      use_case_url(@use_case),
      params: { use_case: { description: @use_case.description, name: @use_case.name, slug: @use_case.slug } }
    )
    assert_response :redirect

    delete use_case_url(@use_case)
    assert_response :redirect
  end

  test 'favoriting should save to saved_use_cases array' do
    delete(destroy_user_session_url)
    post(favorite_use_case_use_case_url(@use_case), as: :json)
    assert_response :unauthorized

    sign_in FactoryBot.create(
      :user, username: 'nonadmin',
      email: 'nonadmin@digitalimpactalliance.org', saved_use_cases: []
    )

    last_user = User.last
    assert_equal(last_user.saved_use_cases.length, 0)

    post(favorite_use_case_use_case_url(@use_case), as: :json)
    assert_response :ok

    last_user = User.last
    assert_equal(last_user.saved_use_cases.length, 1)
  end

  test 'unfavoriting should remove from saved_use_cases array' do
    delete(destroy_user_session_url)
    post(unfavorite_use_case_use_case_url(@use_case), as: :json)
    assert_response :unauthorized

    sign_in FactoryBot.create(:user, email: 'nonadmin@digitalimpactalliance.org', saved_use_cases: [@use_case.id])

    last_user = User.last
    assert_equal(last_user.saved_use_cases.length, 1)

    post(unfavorite_use_case_use_case_url(@use_case), as: :json)
    assert_response :ok

    last_user = User.last
    assert_equal(last_user.saved_use_cases.length, 0)
  end

  test 'content editor user should be able to remove mapping' do
    delete(destroy_user_session_url)
    sign_in(
      FactoryBot.create(:user, username: 'content_editor', email: 'content_editor@abba.org', roles: ['content_editor'])
    )

    assert_difference('UseCase.count') do
      post use_cases_url, params: { use_case: { uc_desc: @use_case.description, name: @use_case.name,
                                                maturity: 'BETA',
                                                sector_id: @use_case.sector_id, slug: @use_case.slug } }
    end

    created_use_case = UseCase.last
    assert_redirected_to use_case_url(created_use_case)

    assert_equal(created_use_case.sdg_targets.length, 0)

    created_audit = Audit.last
    assert_equal(created_audit.action, 'CREATED')
    assert_equal(created_audit.username, 'content_editor@abba.org')

    # Audit will have 3 elements:
    # * Base entity changes.
    # * Mapping changes (optional)
    # * Image changes (optional)
    assert_equal(created_audit.audit_changes.length, 1)

    # sdg_target = sdg_targets(:one)
    # other_target = sdg_targets(:two)
    uc_params = {
      use_case: {
        name: created_use_case.name,
        slug: created_use_case.slug,
        description: 'Updated desc'
      }
    }

    patch use_case_url(created_use_case), params: uc_params

    updated_use_case = UseCase.find(created_use_case.id)
    assert_redirected_to use_case_url(updated_use_case, locale: 'en')

    created_audit = Audit.last
    assert_equal(created_audit.action, 'UPDATED')
    assert_equal(created_audit.username, 'content_editor@abba.org')

    # Audit will have 1 elements:
    # * Mapping changes (optional)
    assert_equal(created_audit.audit_changes.length, 1)
  end
end
