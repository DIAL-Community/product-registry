require 'test_helper'

class UseCasesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in FactoryBot.create(:user, role: :admin)
    @use_case = use_cases(:one)
  end

  test "should get index" do
    get use_cases_url
    assert_response :success
  end

  test "search test" do
    get use_cases_url(:search=>"UseCase1")
    assert_equal(1, assigns(:use_cases).count)

    get use_cases_url(:search=>"InvalidUseCase")
    assert_equal(0, assigns(:use_cases).count)
  end

  test "should get new" do
    get new_use_case_url
    assert_response :success
  end

  test "should create use_case" do
    assert_difference('UseCase.count') do
      post use_cases_url, params: { use_case: { description: @use_case.description, name: @use_case.name, sector_id: @use_case.sector_id, slug: @use_case.slug } }
    end

    assert_redirected_to use_case_url(UseCase.last)
  end

  test "should show use_case" do
    get use_case_url(@use_case)
    assert_response :success
  end

  test "should get edit" do
    get edit_use_case_url(@use_case)
    assert_response :success
  end

  test "should update use_case" do
    patch use_case_url(@use_case), params: { use_case: { description: @use_case.description, name: @use_case.name, sector_id: @use_case.sector_id, slug: @use_case.slug } }
    assert_redirected_to use_case_url(@use_case)
  end

  test "should destroy use_case" do
    assert_difference('UseCase.count', -1) do
      delete use_case_url(@use_case)
    end

    assert_redirected_to use_cases_url
  end

  test "Policy tests: should reject new, edit, update, delete actions for regular user. Should allow get" do
    sign_in FactoryBot.create(:user, email: 'nonadmin@digitalimpactalliance.org')

    get use_case_url(@use_case)
    assert_response :success
    
    get new_use_case_url
    assert_response :redirect

    get edit_use_case_url(@use_case)
    assert_response :redirect    

    patch use_case_url(@use_case), params: { use_case: { description: @use_case.description, name: @use_case.name, slug: @use_case.slug } }
    assert_response :redirect  

    delete use_case_url(@use_case)
    assert_response :redirect
  end
end
