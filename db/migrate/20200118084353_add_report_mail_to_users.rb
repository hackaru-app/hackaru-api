# frozen_string_literal: true

class AddReportMailToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :receive_week_report,
               :boolean,
               default: true,
               null: false
    add_column :users, :receive_month_report,
               :boolean,
               default: true,
               null: false
  end
end
