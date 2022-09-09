# frozen_string_literal: true

module XhrHeaderHelper
  def xhr_header
    { 'X-Requested-With': 'XMLHttpRequest' }
  end
end

RSpec.configure do |config|
  config.include XhrHeaderHelper, type: :request
  config.include XhrHeaderHelper, type: :controller
end
