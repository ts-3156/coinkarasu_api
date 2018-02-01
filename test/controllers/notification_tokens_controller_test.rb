require 'test_helper'

class NotificationTokensControllerTest < ActionDispatch::IntegrationTest
  setup do
    @notification_token = notification_tokens(:one)
  end

  test "should get index" do
    get notification_tokens_url, as: :json
    assert_response :success
  end

  test "should create notification_token" do
    assert_difference('NotificationToken.count') do
      post notification_tokens_url, params: { notification_token: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show notification_token" do
    get notification_token_url(@notification_token), as: :json
    assert_response :success
  end

  test "should update notification_token" do
    patch notification_token_url(@notification_token), params: { notification_token: {  } }, as: :json
    assert_response 200
  end

  test "should destroy notification_token" do
    assert_difference('NotificationToken.count', -1) do
      delete notification_token_url(@notification_token), as: :json
    end

    assert_response 204
  end
end
