# frozen_string_literal: true

class CreateRefreshTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :refresh_tokens do |t|
      t.references :user, foreign_key: true, null: false
      t.string :token, null: false

      t.timestamps
    end

    add_index :refresh_tokens, :token, unique: true
  end
end
