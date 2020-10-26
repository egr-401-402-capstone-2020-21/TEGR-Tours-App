require "application_system_test_case"

class TimeBlocksTest < ApplicationSystemTestCase
  setup do
    @time_block = time_blocks(:one)
  end

  test "visiting the index" do
    visit time_blocks_url
    assert_selector "h1", text: "Time Blocks"
  end

  test "creating a Time block" do
    visit time_blocks_url
    click_on "New Time Block"

    fill_in "Course", with: @time_block.course_id
    fill_in "End time", with: @time_block.end_time
    fill_in "Start time", with: @time_block.start_time
    fill_in "Week day", with: @time_block.week_day
    click_on "Create Time block"

    assert_text "Time block was successfully created"
    click_on "Back"
  end

  test "updating a Time block" do
    visit time_blocks_url
    click_on "Edit", match: :first

    fill_in "Course", with: @time_block.course_id
    fill_in "End time", with: @time_block.end_time
    fill_in "Start time", with: @time_block.start_time
    fill_in "Week day", with: @time_block.week_day
    click_on "Update Time block"

    assert_text "Time block was successfully updated"
    click_on "Back"
  end

  test "destroying a Time block" do
    visit time_blocks_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Time block was successfully destroyed"
  end
end
