require 'test_helper'

class Coincheck::SalesRatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @coincheck_sales_rate = coincheck_sales_rates(:one)
  end

  test "should get index" do
    get coincheck_sales_rates_url, as: :json
    assert_response :success
  end

  test "should create coincheck_sales_rate" do
    assert_difference('Coincheck::SalesRate.count') do
      post coincheck_sales_rates_url, params: { coincheck_sales_rate: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show coincheck_sales_rate" do
    get coincheck_sales_rate_url(@coincheck_sales_rate), as: :json
    assert_response :success
  end

  test "should update coincheck_sales_rate" do
    patch coincheck_sales_rate_url(@coincheck_sales_rate), params: { coincheck_sales_rate: {  } }, as: :json
    assert_response 200
  end

  test "should destroy coincheck_sales_rate" do
    assert_difference('Coincheck::SalesRate.count', -1) do
      delete coincheck_sales_rate_url(@coincheck_sales_rate), as: :json
    end

    assert_response 204
  end
end
