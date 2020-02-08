# frozen_string_literal: true

class AddTimestampColumnsToActivityCalendars < ActiveRecord::Migration[6.0]
  def change
    add_timestamps :activity_calendars, null: false, default: -> { 'NOW()' }
    change_column_default :activity_calendars, :created_at, nil
    change_column_default :activity_calendars, :updated_at, nil
  end
end
