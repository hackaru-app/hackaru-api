# frozen_string_literal: true

class CreateActivityCalendars < ActiveRecord::Migration[6.0]
  def change
    create_table :activity_calendars do |t|
      t.references :user, null: false, index: { unique: true }
      t.string :token

      t.timestamps
    end

    add_foreign_key :activity_calendars, :users, on_delete: :cascade
    add_index :activity_calendars, :token, unique: true
  end
end
