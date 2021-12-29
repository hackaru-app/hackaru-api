# frozen_string_literal: true

class AddExpiredAtToResetPasswordTokens < ActiveRecord::Migration[5.2]
  def change
    change_table :reset_password_tokens, bulk: true do |t|
      t.datetime :expired_at, null: false
    end
  end
end
