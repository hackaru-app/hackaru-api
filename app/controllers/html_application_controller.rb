# frozen_string_literal: true

class HtmlApplicationController < ApplicationController
  include HttpAcceptLanguage::AutoLocale
  include Authenticatable
  include ErrorRenderable
  include RavenExtraContext
end
