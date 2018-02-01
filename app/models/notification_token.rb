class NotificationToken < ApplicationRecord
  validates :uuid, presence: true, uniqueness: true, format: {with: /\A[0-9a-z-]{20,40}+\z/}

  # 仕様がはっきりしないため、厳密なバリデーションは行っていない format: {with: /\A[0-9a-zA-Z:-_]{100,200}+\z/}
  validates :token, presence: true, uniqueness: true, length: {in: 100..200}

  class << self
    def as_json(options = nil)
      super(only: %i(created_at))
    end

  end
end
