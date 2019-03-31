# frozen_string_literal: true

OkComputer::Registry.register(
  'redis',
  OkComputer::RedisCheck.new(
    url: ENV.fetch('REDIS_URL', 'redis://redis:6379/0')
  )
)

%i[default mailers].each do |queue|
  OkComputer::Registry.register(
    "sidekiq_#{queue}_queue",
    OkComputer::SidekiqLatencyCheck.new(
      "hackaru-api_#{Rails.env}_#{queue}"
    )
  )
end
