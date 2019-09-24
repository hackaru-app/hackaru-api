# frozen_string_literal: true

class ApplicationController < ActionController::API
  include HttpAcceptLanguage::AutoLocale
  include Authenticatable
  include ErrorRenderable
  include RavenContext
end
