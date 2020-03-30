require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in FactoryBot.create(:user, role: :admin)
    @project = projects(:one)
  end

  test "should get index" do
    get projects_url
    assert_response :success
  end

  test "should get show" do
    get project_url(@project)
    assert_response :success
  end

  test "search test" do
    get projects_url(search: 'Project A')
    assert_equal(1, assigns(:projects).count)

    get projects_url(search: 'Invalid Project')
    assert_equal(0, assigns(:projects).count)
  end

  test "should get new" do
    get new_project_url
    assert_response :success
  end

  test "should create project" do
    assert_difference('Project.count') do
      post projects_url, params: { project: { name: @project.name, sectors: @project.sectors, slug: @project.slug, origin_id: @project.origin.id } }
    end

    assert_redirected_to project_url(Project.last)
  end

  test "should fail on project create with no origin" do
    @project.origin = nil
    
    assert @project.invalid?
  end

  test "should get edit" do
    get edit_project_url(@project)
    assert_response :success
  end

  test "should update project" do
    patch project_url(@project), params: { project: { name: @project.name, sectors: @project.sectors, slug: @project.slug } }
    assert_redirected_to project_url(@project)
  end

  test "should destroy project" do
    assert_difference('Project.count', -1) do
      delete project_url(@project)
    end

    assert_redirected_to projects_url
  end

  test "add projects filter" do
    # With no filters, should load 2 workflows
    get projects_url
    assert_equal(2, assigns(:projects).count)
    project1 = assigns(:projects)[0]
    project2 = assigns(:projects)[1]

    param = {'filter_name' => 'projects', 'filter_value' => project1.id, 'filter_label' => project1.name}
    post "/add_filter", params: param

    # Filter is set, should only load 1
    get projects_url
    assert_equal(1, assigns(:projects).count)

    # TODO: Finish these tests once product and org filters are implemented for products
    # Now add a workflow filter
    #param = {'filter_name' => 'workflows', 'filter_value' => use_case2.workflows[0].id, 'filter_label' => use_case2.workflows[0].name}
    #post "/add_filter", params: param

    # With additional filter, should now load 0
    #get use_cases_url
    #assert_equal(0, assigns(:use_cases).count)

  end

  test "Policy tests: Should only allow get" do
    sign_in FactoryBot.create(:user, email: 'nonadmin@digitalimpactalliance.org')

    get project_url(@project)
    assert_response :success
    
    get new_project_url
    assert_response :redirect

    get edit_project_url(@project)
    assert_response :redirect    

    patch project_url(@project), params: { project: { name: @project.name, slug: @project.slug } }
    assert_response :redirect  

    delete project_url(@project)
    assert_response :redirect
  end

end
