class App < ApplicationRecord
  class << self
    def generate!(uuid:)
      key = SecureRandom.uuid.remove('-')
      secret = SecureRandom.uuid.remove('-')
      create!(uuid: uuid, key: key, secret: secret)
    end

    def as_json(options = nil)
      super(only: %i(key secret created_at))
    end
  end
end
