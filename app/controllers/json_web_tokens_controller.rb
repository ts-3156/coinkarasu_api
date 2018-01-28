class JsonWebTokensController < ApplicationController
  def verify
    nonce = params[:nonce]
    token = params[:token]
    return render json: {} if nonce.blank? || token.blank? || token.split('.').length != 3

    jwt = JsonWebToken.new(token)

    return render json: {} if !jwt.verify? ||
        nonce != Base64.decode64(jwt.payload['nonce']) ||
        jwt.payload['ctsProfileMatch'].to_s != 'true' ||
        jwt.payload['timestampMs'].to_i < 1.minute.ago.to_i ||
        jwt.payload['apkPackageName'] != 'com.coinkarasu'

    render json: {is_valid_signature: true}
  end
end
