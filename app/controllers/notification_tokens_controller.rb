class NotificationTokensController < ApplicationController
  before_action :verify_request

  def create
    token = NotificationToken.new(uuid: params[:uuid], token: params[:token])

    # ここでは App.exists?(uuid: token.uuid) の確認は行っていない。
    # アプリ側で、AppとNotificationTokenの保存の順番が前後する可能性があるため。
    return render json: {}, status: :unprocessable_entity unless token.valid?

    if token.save
      render json: token, status: :created
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  def update
    token = NotificationToken.find_by(uuid: params[:uuid])
    if token&.update!(token: params[:token])
      render json: token
    else
      render json: {}
    end
  end
end
