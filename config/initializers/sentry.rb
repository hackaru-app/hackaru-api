# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = ENV['SENTRY_DSN']
  config.environment = ENV['SENTRY_ENVIRONMENT']
  config.breadcrumbs_logger = [:active_support_logger]
  config.traces_sample_rate = 0.5

  config.excluded_exceptions += [
    'ActiveRecord::RecordNotFound',
    'ActiveRecord::RecordInvalid',
    'ActionController::RoutingError'
  ]

  filter = ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters)
  config.before_send = lambda do |event, _hint|
    filter.filter(event.to_hash)
  end
end
