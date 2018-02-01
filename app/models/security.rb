require 'openssl'

class Security
  class << self
    def sign(secret, nonce, url)
      OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), secret, nonce + url)
    end

    def verify?(request)
      key = request.headers[:HTTP_ACCESS_KEY]
      nonce = request.headers[:HTTP_ACCESS_NONCE]
      signature = request.headers[:HTTP_ACCESS_SIGNATURE]

      return false if key.blank? || nonce.blank? || signature.blank?
      return false if !nonce.match?(/\A\d+\z/) || nonce.to_i < 1.minute.ago.to_i

      (app = App.find_by(key: key)) && sign(app.secret, nonce, request.url) == signature
    end
  end
end