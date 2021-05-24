# frozen_string_literal: true

class RemoveWebhooks < ActiveRecord::Migration[6.1]
  def up
    drop_table :webhooks
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
