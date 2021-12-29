# frozen_string_literal: true

Rails.configuration.exceptions_app = lambda do |env|
  ExceptionsController.action(:show).call(env)
end
