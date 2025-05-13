require "test_helper"

class CarbonEmissionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @carbon_emission = carbon_emissions(:one)
  end

  test "should get index" do
    get carbon_emissions_url
    assert_response :success
  end

  test "should get new" do
    get new_carbon_emission_url
    assert_response :success
  end

  test "should create carbon_emission" do
    assert_difference("CarbonEmission.count") do
      post carbon_emissions_url, params: { carbon_emission: { announcement_date: @carbon_emission.announcement_date, carbon_emission_value: @carbon_emission.carbon_emission_value, category: @carbon_emission.category, item_name: @carbon_emission.item_name, period_range: @carbon_emission.period_range, production_area: @carbon_emission.production_area, unit: @carbon_emission.unit } }
    end

    assert_redirected_to carbon_emission_url(CarbonEmission.last)
  end

  test "should show carbon_emission" do
    get carbon_emission_url(@carbon_emission)
    assert_response :success
  end

  test "should get edit" do
    get edit_carbon_emission_url(@carbon_emission)
    assert_response :success
  end

  test "should update carbon_emission" do
    patch carbon_emission_url(@carbon_emission), params: { carbon_emission: { announcement_date: @carbon_emission.announcement_date, carbon_emission_value: @carbon_emission.carbon_emission_value, category: @carbon_emission.category, item_name: @carbon_emission.item_name, period_range: @carbon_emission.period_range, production_area: @carbon_emission.production_area, unit: @carbon_emission.unit } }
    assert_redirected_to carbon_emission_url(@carbon_emission)
  end

  test "should destroy carbon_emission" do
    assert_difference("CarbonEmission.count", -1) do
      delete carbon_emission_url(@carbon_emission)
    end

    assert_redirected_to carbon_emissions_url
  end
end
