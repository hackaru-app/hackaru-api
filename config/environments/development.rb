# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded any time
  # it changes. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # For use exceptions_app
  config.consider_all_requests_local = false

  # Disable server timing
  config.server_timing = false

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Uncomment if you wish to allow Action Cable access from any origin.
  # config.action_cable.disable_request_forgery_protection = true

  config.file_watcher = ActiveSupport::FileUpdateChecker

  config.active_job.queue_adapter     = :sidekiq
  config.active_job.queue_name_prefix = "hackaru-api_#{Rails.env}"

  # Enable i18n fallbacks
  config.i18n.fallbacks = [I18n.default_locale]

  # Enable rack attack
  Rack::Attack.enabled = true

  config.action_mailer.delivery_method =
    ENV.fetch('SMTP_DELIVERY_METHOD', 'smtp').to_sym

  config.action_mailer.asset_host =
    "http://#{ENV.fetch('SMTP_ASSET_HOST', 'localhost:3000')}"

  config.action_mailer.default_url_options = {
    host: ENV.fetch('SMTP_DEFAULT_URL_HOST', 'localhost:3000'),
    protocol: 'http'
  }

  config.action_mailer.smtp_settings = {
    address: ENV.fetch('SMTP_ADDRESS', 'mailcatcher'),
    port: ENV.fetch('SMTP_PORT', '1025'),
    domain: ENV.fetch('SMTP_DOMAIN', nil),
    user_name: ENV.fetch('SMTP_USER_NAME', nil),
    password: ENV.fetch('SMTP_PASSWORD', nil),
    authentication: ENV.fetch('SMTP_AUTHENTICATION', 'plain'),
    enable_starttls_auto: ENV.fetch('SMTP_ENABLE_STARTTLS_AUTO', true)
  }
end
