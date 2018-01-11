class Coincheck::SalesRatesController < ApplicationController
  before_action :set_coincheck_sales_rate, only: [:show, :update, :destroy]

  # GET /coincheck/sales_rates
  def index
    @coincheck_sales_rates = Coincheck::SalesRate.all

    render json: @coincheck_sales_rates
  end

  # GET /coincheck/sales_rates/1
  def show
    render json: @coincheck_sales_rate
  end

  # POST /coincheck/sales_rates
  def create
    @coincheck_sales_rate = Coincheck::SalesRate.new(coincheck_sales_rate_params)

    if @coincheck_sales_rate.save
      render json: @coincheck_sales_rate, status: :created, location: @coincheck_sales_rate
    else
      render json: @coincheck_sales_rate.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /coincheck/sales_rates/1
  def update
    if @coincheck_sales_rate.update(coincheck_sales_rate_params)
      render json: @coincheck_sales_rate
    else
      render json: @coincheck_sales_rate.errors, status: :unprocessable_entity
    end
  end

  # DELETE /coincheck/sales_rates/1
  def destroy
    @coincheck_sales_rate.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_coincheck_sales_rate
      @coincheck_sales_rate = Coincheck::SalesRate.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def coincheck_sales_rate_params
      params.fetch(:coincheck_sales_rate, {})
    end
end
