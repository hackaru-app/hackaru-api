# frozen_string_literal: true

module OAuth
  class AuthorizationsController < Doorkeeper::AuthorizationsController
    private

    def matching_token?
      nil
    end
  end
end
