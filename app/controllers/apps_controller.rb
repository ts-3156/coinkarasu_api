class AppsController < ApplicationController
  before_action :verify_request

  def create
    uuid = params[:uuid]
    return render json: {}, status: :unprocessable_entity if uuid.blank? ||
        !uuid.match?(/\A[0-9a-z-]{20,40}+\z/) || App.exists?(uuid: uuid)

    render json: App.generate!(uuid: uuid), status: :created
  end
end
