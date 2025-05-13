require "application_system_test_case"

class CarbonEmissionsTest < ApplicationSystemTestCase
  setup do
    @carbon_emission = carbon_emissions(:one)
  end

  test "visiting the index" do
    visit carbon_emissions_url
    assert_selector "h1", text: "Carbon emissions"
  end

  test "should create carbon emission" do
    visit carbon_emissions_url
    click_on "New carbon emission"

    fill_in "Announcement date", with: @carbon_emission.announcement_date
    fill_in "Carbon emission value", with: @carbon_emission.carbon_emission_value
    fill_in "Category", with: @carbon_emission.category
    fill_in "Item name", with: @carbon_emission.item_name
    fill_in "Period range", with: @carbon_emission.period_range
    fill_in "Production area", with: @carbon_emission.production_area
    fill_in "Unit", with: @carbon_emission.unit
    click_on "Create Carbon emission"

    assert_text "Carbon emission was successfully created"
    click_on "Back"
  end

  test "should update Carbon emission" do
    visit carbon_emission_url(@carbon_emission)
    click_on "Edit this carbon emission", match: :first

    fill_in "Announcement date", with: @carbon_emission.announcement_date.to_s
    fill_in "Carbon emission value", with: @carbon_emission.carbon_emission_value
    fill_in "Category", with: @carbon_emission.category
    fill_in "Item name", with: @carbon_emission.item_name
    fill_in "Period range", with: @carbon_emission.period_range
    fill_in "Production area", with: @carbon_emission.production_area
    fill_in "Unit", with: @carbon_emission.unit
    click_on "Update Carbon emission"

    assert_text "Carbon emission was successfully updated"
    click_on "Back"
  end

  test "should destroy Carbon emission" do
    visit carbon_emission_url(@carbon_emission)
    click_on "Destroy this carbon emission", match: :first

    assert_text "Carbon emission was successfully destroyed"
  end
end
