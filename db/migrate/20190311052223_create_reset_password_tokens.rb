# frozen_string_literal: true

class CreateResetPasswordTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :reset_password_tokens do |t|
      t.references :user,
                   null: false,
                   index: { unique: true },
                   foreign_key: true
      t.string :token, null: false

      t.timestamps
    end

    add_index :reset_password_tokens, :token, unique: true
  end
end
