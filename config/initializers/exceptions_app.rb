# frozen_string_literal: true

Rails.configuration.exceptions_app = lambda do |env|
  ApplicationController.action(:render_exception).call(env)
end
