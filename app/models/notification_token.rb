class NotificationToken < ApplicationRecord
  validates :uuid, presence: true, uniqueness: true, format: {with: /\A[0-9a-z-]{20,40}+\z/}
  validates :token, presence: true, uniqueness: true, format: {with: /\A[0-9a-z-]{100,200}+\z/}

  class << self
    def as_json(options = nil)
      super(only: %i(created_at))
    end

  end
end
