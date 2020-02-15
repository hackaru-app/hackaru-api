# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.3'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
end

group :development do
  gem 'brakeman'
  gem 'listen', '>= 3.0.5', '< 3.3'
  gem 'rubocop', require: false
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'slim_lint'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'json_spec'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'simplecov', '>= 0.17.0', require: false
  gem 'webmock'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'active_model_serializers', '~> 0.10.10'
gem 'aws-ses'
gem 'bcrypt'
gem 'date_validator'
gem 'doorkeeper'
gem 'doorkeeper-i18n'
gem 'faraday'
gem 'groupdate'
gem 'http_accept_language'
gem 'icalendar'
gem 'jwt'
gem 'okcomputer'
gem 'premailer-rails'
gem 'rack-attack'
gem 'rack-cors', require: 'rack/cors'
gem 'rails-i18n', '~> 6.0 '
gem 'rails_param'
gem 'ransack'
gem 'sentry-raven'
gem 'sidekiq'
gem 'sidekiq-cron', '~> 1.1'
gem 'slim'
gem 'webpacker'
gem 'draper'
