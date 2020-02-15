# frozen_string_literal: true

class AddExpiredAtToResetPasswordToken < ActiveRecord::Migration[5.2]
  def change
    add_column :reset_password_tokens, :expired_at, :datetime, null: false
  end
end
