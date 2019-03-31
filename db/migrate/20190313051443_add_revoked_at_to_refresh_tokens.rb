# frozen_string_literal: true

class AddRevokedAtToRefreshTokens < ActiveRecord::Migration[5.2]
  def change
    add_column :refresh_tokens, :revoked_at, :datetime
  end
end
