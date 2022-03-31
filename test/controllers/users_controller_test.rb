# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in FactoryBot.create(:user, roles: [:admin])
    @user = users(:one)
  end

  test 'should get index' do
    get users_url
    assert_response :success
  end

  test 'should get edit' do
    get edit_user_url(@user)
    assert_response :success
  end

  test 'Policy tests: should reject edit and get for regular user.' do
    sign_in FactoryBot.create(:user, username: 'nonadmin', email: 'nonadmin@digitalimpactalliance.org')

    get user_url(@user)
    assert_response :redirect

    get edit_user_url(@user)
    assert_response :redirect
  end
end
