# frozen_string_literal: true

class AddClientIdToRefreshTokens < ActiveRecord::Migration[5.2]
  def change
    change_table :refresh_tokens, bulk: true do |t|
      t.string :client_id, null: false
    end

    add_index :refresh_tokens, :client_id, unique: true
  end
end
