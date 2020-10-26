require 'test_helper'

class TimeBlocksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @time_block = time_blocks(:one)
  end

  test "should get index" do
    get time_blocks_url
    assert_response :success
  end

  test "should get new" do
    get new_time_block_url
    assert_response :success
  end

  test "should create time_block" do
    assert_difference('TimeBlock.count') do
      post time_blocks_url, params: { time_block: { course_id: @time_block.course_id, end_time: @time_block.end_time, start_time: @time_block.start_time, week_day: @time_block.week_day } }
    end

    assert_redirected_to time_block_url(TimeBlock.last)
  end

  test "should show time_block" do
    get time_block_url(@time_block)
    assert_response :success
  end

  test "should get edit" do
    get edit_time_block_url(@time_block)
    assert_response :success
  end

  test "should update time_block" do
    patch time_block_url(@time_block), params: { time_block: { course_id: @time_block.course_id, end_time: @time_block.end_time, start_time: @time_block.start_time, week_day: @time_block.week_day } }
    assert_redirected_to time_block_url(@time_block)
  end

  test "should destroy time_block" do
    assert_difference('TimeBlock.count', -1) do
      delete time_block_url(@time_block)
    end

    assert_redirected_to time_blocks_url
  end
end
