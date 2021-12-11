# frozen_string_literal: true

class AddStartDayToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :start_day, :integer, null: true
    change_column_null :users, :start_day, false, 0
  end
end
