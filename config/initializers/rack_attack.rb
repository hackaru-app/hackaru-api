# frozen_string_literal: true

module Rack
  class Attack
    throttle('/v1/auth/users', limit: 5, period: 30.minutes) do |req|
      req.ip if req.path == '/v1/auth/users'
    end

    throttle('/v1/oauth/authorize', limit: 25, period: 5.minutes) do |req|
      req.ip if req.path == '/v1/oauth/authorize'
    end

    throttle('/v1/auth/*', limit: 25, period: 5.minutes) do |req|
      req.ip if req.path.start_with?('/v1/auth')
    end

    throttle('/v1/oauth/*', limit: 300, period: 5.minutes) do |req|
      req.ip if req.path.start_with?('/v1/oauth')
    end

    throttle('/v1', limit: 300, period: 5.minutes) do |req|
      if req.path.start_with?('/v1')
        req.cookies['auth_token_id'] ||
          req.get_header('HTTP_AUTHORIZATION') ||
          req.ip
      end
    end

    def self.throttled_headers(now, period, limit)
      {
        'Content-Type' => 'application/json',
        'RateLimit-Limit' => limit.to_s,
        'RateLimit-Remaining' => '0',
        'RateLimit-Reset' => (now + (period - (now % period))).to_s
      }
    end

    self.throttled_responder = lambda do |request|
      status = I18n.t('rack_attack.throttled.status')
      message = I18n.t('rack_attack.throttled.message')
      headers = throttled_headers(
        request.env['rack.attack.match_data'][:epoch_time],
        request.env['rack.attack.match_data'][:period],
        request.env['rack.attack.match_data'][:limit]
      )
      [status, headers, [{ message: message }.to_json]]
    end
  end
end
