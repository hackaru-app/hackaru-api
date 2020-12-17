# frozen_string_literal: true

class AddReportMailToUsers < ActiveRecord::Migration[6.0]
  def change
    change_table :users, bulk: true do |t|
      t.boolean :receive_week_report, default: true, null: false
      t.boolean :receive_month_report, default: true, null: false
    end
  end
end
