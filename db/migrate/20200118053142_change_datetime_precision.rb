# frozen_string_literal: true

class ChangeDatetimePrecision < ActiveRecord::Migration[6.0]
  def change
    change_column :activities, :created_at, :datetime, precision: 6
    change_column :activities, :updated_at, :datetime, precision: 6

    change_column :password_reset_tokens, :created_at, :datetime, precision: 6
    change_column :password_reset_tokens, :updated_at, :datetime, precision: 6

    change_column :projects, :created_at, :datetime, precision: 6
    change_column :projects, :updated_at, :datetime, precision: 6

    change_column :refresh_tokens, :created_at, :datetime, precision: 6
    change_column :refresh_tokens, :updated_at, :datetime, precision: 6

    change_column :users, :created_at, :datetime, precision: 6
    change_column :users, :updated_at, :datetime, precision: 6

    change_column :webhooks, :created_at, :datetime, precision: 6
    change_column :webhooks, :updated_at, :datetime, precision: 6
  end
end
