# frozen_string_literal: true

class UpdateForeignKeysOfUser < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key 'activities', 'users'
    remove_foreign_key 'password_reset_tokens', 'users'
    remove_foreign_key 'projects', 'users'
    remove_foreign_key 'refresh_tokens', 'users'
    remove_foreign_key 'webhooks', 'users'

    add_foreign_key 'activities', 'users', on_delete: :cascade
    add_foreign_key 'password_reset_tokens', 'users', on_delete: :cascade
    add_foreign_key 'projects', 'users', on_delete: :cascade
    add_foreign_key 'refresh_tokens', 'users', on_delete: :cascade
    add_foreign_key 'webhooks', 'users', on_delete: :cascade
  end
end
