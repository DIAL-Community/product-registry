require 'test_helper'

class SdgTargetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sdg_target = sdg_targets(:one)
  end

  test "should get index" do
    get sdg_targets_url
    assert_response :success
  end

  test "should get new" do
    get new_sdg_target_url
    assert_response :success
  end

  test "should create sdg_target" do
    assert_difference('SdgTarget.count') do
      post sdg_targets_url, params: { sdg_target: { name: @sdg_target.name, number: @sdg_target.number, slug: @sdg_target.slug, sustainable_development_goals_id: @sdg_target.sustainable_development_goals_id } }
    end

    assert_redirected_to sdg_target_url(SdgTarget.last)
  end

  test "should show sdg_target" do
    get sdg_target_url(@sdg_target)
    assert_response :success
  end

  test "should get edit" do
    get edit_sdg_target_url(@sdg_target)
    assert_response :success
  end

  test "should update sdg_target" do
    patch sdg_target_url(@sdg_target), params: { sdg_target: { name: @sdg_target.name, number: @sdg_target.number, slug: @sdg_target.slug, sustainable_development_goals_id: @sdg_target.sustainable_development_goals_id } }
    assert_redirected_to sdg_target_url(@sdg_target)
  end

  test "should destroy sdg_target" do
    assert_difference('SdgTarget.count', -1) do
      delete sdg_target_url(@sdg_target)
    end

    assert_redirected_to sdg_targets_url
  end
end
