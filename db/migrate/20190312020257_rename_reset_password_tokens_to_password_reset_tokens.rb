# frozen_string_literal: true

class RenameResetPasswordTokensToPasswordResetTokens <
    ActiveRecord::Migration[5.2]
  def change
    rename_table :reset_password_tokens, :password_reset_tokens
  end
end
