# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins(/^#{ENV.fetch('HACKARU_WEB_URL')}$/)

    resource '/auth/*',
             headers: :any,
             methods: %i[get post put patch options delete],
             credentials: true

    resource '/oauth/*',
             headers: :any,
             methods: %i[get post put patch options delete],
             credentials: true

    resource '/v1/*',
             headers: :any,
             methods: %i[get post put patch options delete],
             credentials: true
  end

  allow do
    origins '*'

    # DEPRECATED
    resource '/v1/auth/*',
             headers: [],
             methods: [],
             credentials: false

    # DEPRECATED
    resource '/v1/oauth/authorize',
             headers: [],
             methods: [],
             credentials: false

    # DEPRECATED
    resource '/v1/oauth/*',
             headers: :any,
             methods: %i[get post put patch options delete],
             credentials: false

    resource '/v1/*',
             headers: :any,
             methods: %i[get post put patch options delete],
             credentials: false
  end
end
