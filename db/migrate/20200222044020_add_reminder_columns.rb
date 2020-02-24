# frozen_string_literal: true

class AddReminderColumns < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :receive_reminder, :boolean, default: true, null: false
    add_column :activities, :reminded, :boolean, default: false, null: false
  end
end
