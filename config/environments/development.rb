# frozen_string_literal: true

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Use eager load code on boot.
  config.eager_load = true

  # Show full error reports.
  config.consider_all_requests_local = false

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options)
  # config.active_storage.service = :local

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false
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

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::FileUpdateChecker

  # Use a real queuing backend for Active Job (and separate queues per environment)
  config.active_job.queue_adapter     = :sidekiq
  config.active_job.queue_name_prefix = "hackaru-api_#{Rails.env}"

  # Enable i18n fallbacks
  config.i18n.fallbacks = [I18n.default_locale]

  # Enable rack attack
  Rack::Attack.enabled = true
end
