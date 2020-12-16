# frozen_string_literal: true

class AddClientIdToRefreshToken < ActiveRecord::Migration[5.2]
  def change
    add_column :refresh_tokens, :client_id, :string
    change_column :refresh_tokens, :client_id, :string, null: false
    add_index :refresh_tokens, :client_id, unique: true
  end
end
