class Coincheck::TradingRatesController < ApplicationController
  before_action :set_coincheck_trading_rate, only: [:show, :update, :destroy]

  # GET /coincheck/trading_rates
  def index
    @coincheck_trading_rates = Coincheck::TradingRate.all

    render json: @coincheck_trading_rates
  end

  # GET /coincheck/trading_rates/1
  def show
    render json: @coincheck_trading_rate
  end

  # POST /coincheck/trading_rates
  def create
    @coincheck_trading_rate = Coincheck::TradingRate.new(coincheck_trading_rate_params)

    if @coincheck_trading_rate.save
      render json: @coincheck_trading_rate, status: :created, location: @coincheck_trading_rate
    else
      render json: @coincheck_trading_rate.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /coincheck/trading_rates/1
  def update
    if @coincheck_trading_rate.update(coincheck_trading_rate_params)
      render json: @coincheck_trading_rate
    else
      render json: @coincheck_trading_rate.errors, status: :unprocessable_entity
    end
  end

  # DELETE /coincheck/trading_rates/1
  def destroy
    @coincheck_trading_rate.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_coincheck_trading_rate
      @coincheck_trading_rate = Coincheck::TradingRate.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def coincheck_trading_rate_params
      params.fetch(:coincheck_trading_rate, {})
    end
end
