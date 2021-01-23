# frozen_string_literal: true

class CreateAuthTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :auth_tokens do |t|
      t.references :user, null: false
      t.string :token, null: false
      t.datetime :expired_at, null: false

      t.timestamps
    end

    add_index :auth_tokens, :token, unique: true
  end
end
