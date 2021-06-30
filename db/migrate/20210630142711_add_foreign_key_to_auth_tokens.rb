# frozen_string_literal: true

class AddForeignKeyToAuthTokens < ActiveRecord::Migration[6.1]
  def change
    add_foreign_key :auth_tokens, :users, on_delete: :cascade
  end
end
