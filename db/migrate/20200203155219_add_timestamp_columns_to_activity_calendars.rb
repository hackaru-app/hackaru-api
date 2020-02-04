# frozen_string_literal: true

class AddTimestampColumnsToActivityCalendars < ActiveRecord::Migration[6.0]
  def change
    add_timestamps :activity_calendars, null: false, default: -> { 'NOW()' }
  end
end
