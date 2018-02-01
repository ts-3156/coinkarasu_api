class ApplicationController < ActionController::API

  private

  def verify_request
    head :forbidden if ENV['VERIFY_REQUEST'].present? && !Security.verify?(request)
  end
end
