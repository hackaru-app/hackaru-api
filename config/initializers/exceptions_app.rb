# frozen_string_literal: true

Rails.configuration.exceptions_app = ExceptionsController.action(:show)
