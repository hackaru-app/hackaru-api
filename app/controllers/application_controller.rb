# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include HttpAcceptLanguage::AutoLocale
  include Authenticatable
  include ErrorRenderable
  include RavenExtraContext
end
