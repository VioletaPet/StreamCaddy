require "test_helper"

class UserProvidersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_providers_index_url
    assert_response :success
  end

  test "should get new" do
    get user_providers_new_url
    assert_response :success
  end

  test "should get create" do
    get user_providers_create_url
    assert_response :success
  end
end
