# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
# require "active_storage/engine"
require 'action_controller/railtie'
require 'action_mailer/railtie'
# require "action_mailbox/engine"
# require "action_text/engine"
require 'action_view/railtie'
require 'action_cable/engine'
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module HackaruApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # Disable request forgery protection
    config.action_controller.allow_forgery_protection = false

    # To prevent cors errors when exporting pdf
    config.action_view.preload_links_header = false

    config.action_mailer.preview_path = Rails.root.join('spec/mailers/previews')

    config.i18n.available_locales = %i[ja en]
    config.i18n.load_path += Dir[
      Rails.root.join('config/locales/**/*.{rb,yml}')
    ]

    config.action_dispatch.default_headers['Referrer-Policy'] = 'no-referrer'

    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore

    # DEPRECATED
    config.action_dispatch.cookies_serializer = :marshal

    # DEPRECATED
    config.active_support.key_generator_hash_digest_class = OpenSSL::Digest::SHA1
  end
end
