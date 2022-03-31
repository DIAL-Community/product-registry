# frozen_string_literal: true

require 'test_helper'

class SettingsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in FactoryBot.create(:user, roles: [:admin])
    @setting = settings(:one)
  end

  test 'should get index' do
    get settings_url
    assert_response :success
  end

  test 'should show setting' do
    get setting_url(@setting)
    assert_response :success
  end

  test 'should get edit' do
    get edit_setting_url(@setting)
    assert_response :success
  end

  test 'should update setting' do
    patch setting_url(@setting), params: { setting: { value: @setting.value } }
    assert_redirected_to setting_url(@setting)
  end
end
