require 'test_helper'

class MaturityRubricsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in FactoryBot.create(:user, roles: [:admin])
    @rubric = maturity_rubrics(:one)
  end

  test "should get index" do
    get maturity_rubrics_url
    assert_response :success
  end

  test "search test" do
    get maturity_rubrics_url(search: "Default Rubric")
    assert_equal(1, assigns(:maturity_rubrics).count)

    get maturity_rubrics_url(search: "InvalidRubric")
    assert_equal(0, assigns(:maturity_rubrics).count)
  end

  test "should get new" do
    get new_maturity_rubric_url
    assert_response :success
  end

  test "should create rubric" do
    assert_difference('MaturityRubric.count') do
      post maturity_rubrics_url, params: { maturity_rubric: { name: @rubric.name, slug: 'testslug' } }
    end

    assert_redirected_to maturity_rubric_url(MaturityRubric.last)
  end

  test "should show rubric" do
    get maturity_rubric_url(@rubric)
    assert_response :success
  end

  test "should get edit" do
    get edit_maturity_rubric_url(@rubric)
    assert_response :success
  end

  test "should update rubric" do
    patch maturity_rubric_url(@rubric), params: { maturity_rubric: { name: @rubric.name, slug: @rubric.slug } }
    assert_redirected_to maturity_rubric_url(@rubric)
  end

  test "should destroy rubric" do
    assert_difference('MaturityRubric.count', -1) do
      @indicator = category_indicators(:one)
      @category = rubric_categories(:one)
      @rubric = maturity_rubrics(:one)
      delete category_indicator_url(@indicator)
      delete rubric_category_url(@category)
      delete maturity_rubric_url(@rubric)
    end

    assert_redirected_to maturity_rubrics_url
  end

  test "Policy tests: Should only allow get" do
    sign_in FactoryBot.create(:user, username: 'nonadmin', email: 'nonadmin@digitalimpactalliance.org')

    get maturity_rubric_url(@rubric)
    assert_response :success

    get new_maturity_rubric_url
    assert_response :redirect

    get edit_maturity_rubric_url(@rubric)
    assert_response :redirect

    patch maturity_rubric_url(@rubric), params: { maturity_rubric: { name: @rubric.name, slug: @rubric.slug } }
    assert_response :redirect

    delete maturity_rubric_url(@rubric)
    assert_response :redirect
  end
end
