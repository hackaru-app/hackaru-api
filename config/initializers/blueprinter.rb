# frozen_string_literal: true

Blueprinter.configure do |config|
  config.datetime_format = -> { _1&.as_json }
end
