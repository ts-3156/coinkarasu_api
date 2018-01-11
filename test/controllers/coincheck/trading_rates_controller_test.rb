require 'test_helper'

class Coincheck::TradingRatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @coincheck_trading_rate = coincheck_trading_rates(:one)
  end

  test "should get index" do
    get coincheck_trading_rates_url, as: :json
    assert_response :success
  end

  test "should create coincheck_trading_rate" do
    assert_difference('Coincheck::TradingRate.count') do
      post coincheck_trading_rates_url, params: { coincheck_trading_rate: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show coincheck_trading_rate" do
    get coincheck_trading_rate_url(@coincheck_trading_rate), as: :json
    assert_response :success
  end

  test "should update coincheck_trading_rate" do
    patch coincheck_trading_rate_url(@coincheck_trading_rate), params: { coincheck_trading_rate: {  } }, as: :json
    assert_response 200
  end

  test "should destroy coincheck_trading_rate" do
    assert_difference('Coincheck::TradingRate.count', -1) do
      delete coincheck_trading_rate_url(@coincheck_trading_rate), as: :json
    end

    assert_response 204
  end
end
