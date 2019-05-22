require 'test_helper'

class BuildingBlocksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @building_block = building_blocks(:one)
  end

  test "should get index" do
    get building_blocks_url
    assert_response :success
  end

  test "should get new" do
    get new_building_block_url
    assert_response :success
  end

  test "should create building_block" do
    assert_difference('BuildingBlock.count') do
      post building_blocks_url, params: { building_block: { name: @building_block.name, slug: @building_block.slug } }
    end

    assert_redirected_to building_block_url(BuildingBlock.last)
  end

  test "should show building_block" do
    get building_block_url(@building_block)
    assert_response :success
  end

  test "should get edit" do
    get edit_building_block_url(@building_block)
    assert_response :success
  end

  test "should update building_block" do
    patch building_block_url(@building_block), params: { building_block: { name: @building_block.name, slug: @building_block.slug } }
    assert_redirected_to building_block_url(@building_block)
  end

  test "should destroy building_block" do
    assert_difference('BuildingBlock.count', -1) do
      delete building_block_url(@building_block)
    end

    assert_redirected_to building_blocks_url
  end
end