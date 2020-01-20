# frozen_string_literal: true

class AddTimeZoneToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :time_zone, :string, null: true
    change_column_null :users, :time_zone, false, 'Asia/Tokyo'
  end
end
