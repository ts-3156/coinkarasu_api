require 'openssl'

class Security
  class << self
    def sign(secret, nonce, url)
      OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), secret, nonce + url)
    end

    def verify(request)
      key = request.headers[:ACCESS_KEY]
      nonce = request.headers[:ACCESS_NONCE]
      signature = request.headers[:ACCESS_SIGNATURE]

      return false if (key.blank? || nonce.blank? || signature.blank?)
      return false if !nonce.match?(/\A\d+\z/) || 1.minute.ago > nonce.to_i

      app = App.find_by(key: key)
      return false unless app

      sign(app.secret, nonce, request.url) == signature
    end
  end
end