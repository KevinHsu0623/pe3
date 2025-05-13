require "test_helper"

class MaterialUsagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get material_usages_index_url
    assert_response :success
  end

  test "should get create" do
    get material_usages_create_url
    assert_response :success
  end
end
