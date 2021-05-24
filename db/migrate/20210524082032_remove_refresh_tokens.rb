# frozen_string_literal: true

class RemoveRefreshTokens < ActiveRecord::Migration[6.1]
  def up
    drop_table :refresh_tokens
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
