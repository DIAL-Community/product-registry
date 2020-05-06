require 'test_helper'

class SustainableDevelopmentGoalsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in FactoryBot.create(:user, role: :admin)
    @goal = sustainable_development_goals(:one)
  end

  test "should get index" do
    get sustainable_development_goals_url
    assert_response :success
  end

  test "search test" do
    get sustainable_development_goals_url(:search=>"SDG1")
    assert_equal(1, assigns(:sustainable_development_goals).count)

    get sustainable_development_goals_url(:search=>"InvalidSDG")
    assert_equal(0, assigns(:sustainable_development_goals).count)
  end

  test "should show use_case" do
    get sustainable_development_goal_url(@goal)
    assert_response :success
  end

  test "add SDG filter" do
    # With no filters, should load 2 workflows
    get sustainable_development_goals_url
    assert_equal(2, assigns(:sustainable_development_goals).count)
    sdg1 = assigns(:sustainable_development_goals)[0]
    sdg2 = assigns(:sustainable_development_goals)[1]

    param = { 'filter_name' => 'sdgs', 'filter_value' => sdg1.id, 'filter_label' => sdg1.name }
    post '/add_filter', params: param

    # Filter is set, should only load 1
    get sustainable_development_goals_url
    assert_equal(1, assigns(:sustainable_development_goals).count)
  end

end
