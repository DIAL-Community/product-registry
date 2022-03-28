# frozen_string_literal: true

require 'test_helper'

class WorkflowsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in FactoryBot.create(:user, roles: [:admin])
    @workflow = workflows(:one)
  end

  test 'should get index' do
    get workflows_url
    assert_response :success
  end

  test 'search test' do
    get workflows_url(search: 'Workflow1')
    assert_equal(1, assigns(:workflows).count)

    get workflows_url(search: 'InvalidWorkflow')
    assert_equal(0, assigns(:workflows).count)
  end

  test 'should get new' do
    get new_workflow_url
    assert_response :success
  end

  test 'should create workflow' do
    assert_difference('Workflow.count') do
      post(
        workflows_url,
        params: { workflow: { wf_desc: @workflow.description, name: @workflow.name, slug: @workflow.slug } }
      )
    end

    assert_redirected_to workflow_url(Workflow.last)
  end

  test 'should show workflow' do
    get workflow_url(@workflow)
    assert_response :success
  end

  test 'should get edit' do
    get edit_workflow_url(@workflow)
    assert_response :success
  end

  test 'should update workflow' do
    patch(
      workflow_url(@workflow),
      params: { workflow: { wf_desc: @workflow.description, name: @workflow.name, slug: @workflow.slug } }
    )
    assert_redirected_to workflow_url(@workflow, locale: 'en')
  end

  test 'should destroy workflow' do
    assert_difference('Workflow.count', -1) do
      delete workflow_url(@workflow)
    end

    assert_redirected_to workflows_url
  end

  test 'add workflow filter' do
    # With no filters, should load 2 workflows
    get workflows_url
    assert_equal(2, assigns(:workflows).count)
    workflow1 = assigns(:workflows)[0]
    workflow2 = assigns(:workflows)[1]

    # Now add a workflow filter
    param = { 'filter_name' => 'use_cases', 'filter_value' => workflow2.use_case_steps[0].use_case.id,
              'filter_label' => workflow2.use_case_steps[0].use_case.name }
    post '/add_filter', params: param

    # Filter is set, should only load 1
    get workflows_url
    assert_equal(1, assigns(:workflows).count)

    param = { 'filter_name' => 'workflows', 'filter_value' => workflow1.id, 'filter_label' => workflow1.name }
    post '/add_filter', params: param

    # With additional filter, should now load 0
    get workflows_url
    assert_equal(0, assigns(:workflows).count)
  end

  test 'Policy tests: Should only allow get' do
    sign_in FactoryBot.create(:user, username: 'nonadmin', email: 'nonadmin@digitalimpactalliance.org')

    get workflow_url(@workflow)
    assert_response :success

    get new_workflow_url
    assert_response :redirect

    get edit_workflow_url(@workflow)
    assert_response :redirect

    patch(
      workflow_url(@workflow),
      params: { workflow: { wf_desc: @workflow.description, name: @workflow.name, slug: @workflow.slug } }
    )
    assert_response :redirect

    delete workflow_url(@workflow)
    assert_response :redirect
  end
end
