require "test_helper"

class Admin::AiRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_ai_requests_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_ai_requests_show_url
    assert_response :success
  end
end
