# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::Cookies
  include HttpAcceptLanguage::AutoLocale
  include XhrValidatable
  include AuthTokenStorable
  include Authenticatable
  include ErrorRenderable
  include RavenExtraContext
end
