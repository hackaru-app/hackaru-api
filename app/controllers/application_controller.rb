# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::Cookies
  include HttpAcceptLanguage::AutoLocale
  include ApiErrorRenderable
  include XhrValidatable
  include AuthTokenStorable
  include Authenticatable
end
