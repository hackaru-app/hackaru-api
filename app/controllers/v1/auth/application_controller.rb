# frozen_string_literal: true

module V1
  module Auth
    class ApplicationController < ::ApplicationController
      before_action :validate_xhr!
    end
  end
end
