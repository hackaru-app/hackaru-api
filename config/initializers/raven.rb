# frozen_string_literal: true

Raven.configure do |config|
  filter_headers = %i[
    X-Access-Token
    X-Refresh-Token
    Authorization
  ].freeze

  config.dsn = ENV['SENTRY_DSN']
  config.excluded_exceptions += [ActiveRecord::RecordInvalid]
  config.sanitize_fields = (
    Rails.application.config.filter_parameters +
    filter_headers
  ).map(&:to_s)
end
