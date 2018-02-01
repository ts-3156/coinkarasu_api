class Coincheck::SalesRatesController < ApplicationController
  before_action :verify_request, only: [:index]

  def index
    time = params[:time]
    from_symbol = params[:from_symbol]
    to_symbol = params[:to_symbol]

    return render json: {} if time.blank? || !time.match?(/\A\d+\z/) ||
        from_symbol.blank? || !from_symbol.match?(/\A[A-Z]{1,10}\z/) ||
        to_symbol.blank? || !to_symbol.match?(/\A[A-Z]{1,10}\z/)

    rate = Coincheck::SalesRate.order(created_at: :desc)
               .where('created_at < ?', Time.zone.at(time.to_i))
               .find_by(from_symbol: from_symbol, to_symbol: to_symbol)

    render json: (rate ? rate : {})
  end

  private
  def verify_request
    head :forbidden if ENV['VERIFY_REQUEST'].present? && !Security.verify?(request)
  end
end
