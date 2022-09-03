# frozen_string_literal: true

OkComputer::Registry.register(
  'redis',
  OkComputer::RedisCheck.new(
    url: ENV.fetch('REDIS_URL', 'redis://redis:6379/0')
  )
)
