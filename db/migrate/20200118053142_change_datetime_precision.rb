# frozen_string_literal: true

class ChangeDatetimePrecision < ActiveRecord::Migration[6.0]
  def up
    change_table :activities, bulk: true do |t|
      t.change :created_at, :datetime, precision: 6
      t.change :updated_at, :datetime, precision: 6
    end

    change_table :password_reset_tokens, bulk: true do |t|
      t.change :created_at, :datetime, precision: 6
      t.change :updated_at, :datetime, precision: 6
    end

    change_table :projects, bulk: true do |t|
      t.change :created_at, :datetime, precision: 6
      t.change :updated_at, :datetime, precision: 6
    end

    change_table :refresh_tokens, bulk: true do |t|
      t.change :created_at, :datetime, precision: 6
      t.change :updated_at, :datetime, precision: 6
    end

    change_table :users, bulk: true do |t|
      t.change :created_at, :datetime, precision: 6
      t.change :updated_at, :datetime, precision: 6
    end

    change_table :webhooks, bulk: true do |t|
      t.change :created_at, :datetime, precision: 6
      t.change :updated_at, :datetime, precision: 6
    end
  end
end
