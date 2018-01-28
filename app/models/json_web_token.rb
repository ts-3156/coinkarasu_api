require 'openssl'

class JsonWebToken
  attr_reader :payload

  HOST = 'attest.android.com'

  def initialize(token)
    @payload, @header = JWT.decode(token, nil, false)
  end

  def verify?
    certs = @header['x5c'].map {|c| OpenSSL::X509::Certificate.new(Base64.decode64(c))}
    leaf_cert = certs.first
    cert_chain = certs.drop(1)

    store = OpenSSL::X509::Store.new
    store.set_default_paths

    OpenSSL::SSL.verify_certificate_identity(leaf_cert, HOST) &&
        store.verify(leaf_cert, cert_chain)
  end
end