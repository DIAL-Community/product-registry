# frozen_string_literal: true

require 'test_helper'

class OperatorServicesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in FactoryBot.create(:user, roles: [:admin])
    @operator_service = operator_services(:one)
    @country = countries(:one)
  end

  test 'should get index' do
    get operator_services_url
    assert_response :success
  end

  test 'search test' do
    get operator_services_url(search: 'Operator')
    assert_equal(1, assigns(:operators).count)

    get operator_services_url(search: 'InvalidOrg')
    assert_equal(0, assigns(:operators).count)
  end

  test 'should get new' do
    get new_operator_service_url
    assert_response :success
  end

  test 'should create operator service' do
    # It should create 12 core services for this operator
    assert_difference('OperatorService.count', 12) do
      post operator_services_url, params: { operator_service: { name: 'NewOperator' },
                                            selected_countries: { @country.id => @country.id } }
    end

    assert_redirected_to operator_services_url
  end

  test 'should show operator service' do
    get operator_services_url(id: @operator_service.name)
    assert_response :success
  end

  test 'should get edit' do
    get edit_operator_service_url(id: @operator_service.name)
    assert_response :success
  end

  test 'should update operator service' do
    patch operator_service_url(@operator_service.name), params: { operator_service: { name: @operator_service.name } }
    assert_redirected_to operator_services_url
  end

  test 'should destroy operator service' do
    assert_difference('OperatorService.count', -1) do
      delete operator_service_url(@operator_service.name)
    end

    assert_redirected_to operator_services_url
  end

  test 'Policy tests: should reject all actions for regular user.' do
    sign_in FactoryBot.create(:user, username: 'nonadmin', email: 'nonadmin@digitalimpactalliance.org')

    get operator_service_url(@operator_service.name)
    assert_response :redirect

    get new_operator_service_url
    assert_response :redirect

    get edit_operator_service_url(@operator_service.name)
    assert_response :redirect

    patch operator_service_url(@operator_service.name), params: { organization: { name: @operator_service.name } }
    assert_response :redirect

    delete operator_service_url(@operator_service.name)
    assert_response :redirect
  end
end
