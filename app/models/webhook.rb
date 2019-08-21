# frozen_string_literal: true

class Webhook < ApplicationRecord
  belongs_to :user

  validates :target_url, presence: true,
                         length: { maximum: 1000 },
                         format: /\A#{URI.regexp(%w[http https])}\z/,
                         uniqueness: { scope: %i[user_id event] }

  def deliver(payload)
    conn = Faraday.new(url: target_url)
    conn.post do |req|
      req.body = payload
      req.options.timeout = 5
    end
  end
end
