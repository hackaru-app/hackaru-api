# frozen_string_literal: true

class CreateWebhooks < ActiveRecord::Migration[5.2]
  def change
    create_table :webhooks do |t|
      t.references :user, null: false, foreign_key: true
      t.string :target_url, null: false
      t.string :event, null: false

      t.timestamps
    end

    add_index :webhooks, %i[user_id target_url event], unique: true
  end
end
