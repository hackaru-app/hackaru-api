# frozen_string_literal: true

class AddExpiredAtToResetPasswordTokens < ActiveRecord::Migration[5.2]
  def change
    change_table :reset_password_tokens, bulk: true do |t|
      t.datetime :expired_at
    end

    change_column :reset_password_tokens, :expired_at, :datetime, null: false
  end
end
