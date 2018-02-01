class NotificationTokensController < ApplicationController
  def create
    token = NotificationToken.new(uuid: params[:uuid], token: params[:token])
    return render json: {} if !token.valid? || !App.exists?(uuid: uuid)

    render json: token.tap(&:save!), status: :created
  end

  def update
    render json: NotificationToken.find_by(uuid: params[:uuid])&.update!(token: params[:token])
  end
end
