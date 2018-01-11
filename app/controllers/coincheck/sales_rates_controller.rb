class Coincheck::SalesRatesController < ApplicationController
  before_action :verify, only: [:index]
  before_action :set_coincheck_sales_rate, only: [:show, :update, :destroy]

  # GET /coincheck/sales_rates
  def index
    # @coincheck_sales_rates = Coincheck::SalesRate.all
    time = params[:time]
    from_symbol = params[:from_symbol]
    to_symbol = params[:to_symbol]

    return render json: {} if time.blank? || !time.match(/\A\d+\z/) ||
        from_symbol.blank? || !from_symbol.match(/\A[A-Z]{10}\z/) ||
        to_symbol.blank? || !to_symbol.match(/\A[A-Z]{10}\z/)

    rate = Coincheck::SalesRate.order(created_at: :desc)
               .where('created_at < ?', Time.zone.at(time.to_i))
               .find_by(from_symbol: from_symbol, to_symbol: to_symbol)

    render json: (rate ? rate : {})
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
  def verify
    head :forbidden if ENV['VERIFY_REQUEST'].present? && !Security.verify(request)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_coincheck_sales_rate
    @coincheck_sales_rate = Coincheck::SalesRate.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def coincheck_sales_rate_params
    params.fetch(:coincheck_sales_rate, {})
  end
end
