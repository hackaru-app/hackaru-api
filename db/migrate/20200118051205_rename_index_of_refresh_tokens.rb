# frozen_string_literal: true

class RenameIndexOfRefreshTokens < ActiveRecord::Migration[6.0]
  def change
    rename_index :password_reset_tokens,
                 'index_reset_password_tokens_on_token',
                 'index_password_reset_tokens_on_token'
    rename_index :password_reset_tokens,
                 'index_reset_password_tokens_on_user_id',
                 'index_password_reset_tokens_on_user_id'
  end
end
