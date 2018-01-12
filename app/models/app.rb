class App < ApplicationRecord
  validates :uuid, presence: true, uniqueness: true, format: {with: /\A[0-9a-z-]{20,40}+\z/}
  validates :key, presence: true, uniqueness: true, format: {with: /\A[0-9a-z]{20,40}+\z/}
  validates :secret, presence: true, uniqueness: true, format: {with: /\A[0-9a-z]{20,40}+\z/}

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
